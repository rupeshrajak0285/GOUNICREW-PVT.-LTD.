import '../../../common_libraries.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final ProductLocalStorage localStorage;

  ProductBloc({required this.repository, required this.localStorage})
      // load saved stuff first so recent searches / hearts show up immediately
      : super(ProductState(
          recentSearches: localStorage.getRecentSearches(),
          favouriteIds: localStorage.getFavouriteIds(),
        )) {
    on<FetchProductsEvent>(_onFetchProductsEvent);
    on<LoadMoreProductsEvent>(_onLoadMoreProductsEvent);
    on<SearchProductsEvent>(_onSearchProductsEvent);
    on<SaveRecentSearchEvent>(_onSaveRecentSearchEvent);
    on<RemoveRecentSearchEvent>(_onRemoveRecentSearchEvent);
    on<ClearRecentSearchesEvent>(_onClearRecentSearchesEvent);
    on<ToggleFavouriteEvent>(_onToggleFavouriteEvent);

    add(FetchProductsEvent());
  }

  Future<void> _onFetchProductsEvent(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    // on refresh keep the old list visible, RefreshIndicator shows the spinner
    if (!event.isRefresh) {
      emit(state.copyWith(pageStatus: PageStatus.loading));
    }
    await _loadFirstPage(emit, completer: event.completer);
  }

  Future<void> _onSearchProductsEvent(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.trim();
    if (query == state.searchQuery && state.pageStatus.isSuccess) return;

    emit(state.copyWith(
      searchQuery: query,
      pageStatus: PageStatus.loading,
      products: const [],
      loadMoreFailed: false,
    ));
    await _loadFirstPage(emit);
  }

  /// Shared by normal fetch, refresh and search.
  Future<void> _loadFirstPage(
    Emitter<ProductState> emit, {
    Completer<void>? completer,
  }) async {
    final query = state.searchQuery;

    try {
      final response = query.isEmpty
          ? await repository.getProducts()
          : await repository.searchProducts(query);

      // user typed something new while this request was running,
      // the newer request will update the list so drop this one
      if (query != state.searchQuery) return;

      // only the normal list is cached, search results change all the time
      if (query.isEmpty) {
        await localStorage.cacheProducts(response.products);
      }

      emit(state.copyWith(
        pageStatus: PageStatus.success,
        products: response.products,
        total: response.total,
        isOfflineData: false,
        loadMoreFailed: false,
        lastSyncedAt: DateTime.now(),
        errorMessage: '',
      ));
    } catch (ex) {
      if (query != state.searchQuery) return;
      final message = AppUtils.errorMessage(ex);

      // refresh failed but we already have products - keep them and let the UI show a toast
      if (completer != null && state.products.isNotEmpty) {
        completer.completeError(message);
        return;
      }

      _emitCachedOrError(emit, query, message);
    } finally {
      if (completer != null && !completer.isCompleted) completer.complete();
    }
  }

  /// Api failed -> try local storage before showing the error screen.
  void _emitCachedOrError(
    Emitter<ProductState> emit,
    String query,
    String message,
  ) {
    final cached = localStorage.getCachedProducts();

    if (cached.isEmpty) {
      emit(state.copyWith(pageStatus: PageStatus.failure, errorMessage: message));
      return;
    }

    // search on the saved list when offline, better than showing nothing
    final products = query.isEmpty ? cached : _filterLocally(cached, query);

    emit(state.copyWith(
      pageStatus: PageStatus.success,
      products: products,
      total: products.length,
      isOfflineData: true,
      lastSyncedAt: localStorage.getLastSyncedAt(),
      errorMessage: message,
    ));
  }

  List<ProductModel> _filterLocally(List<ProductModel> products, String query) {
    final keyword = query.toLowerCase();
    return products.where((product) {
      return product.title.toLowerCase().contains(keyword) ||
          product.brand.toLowerCase().contains(keyword) ||
          product.category.toLowerCase().contains(keyword) ||
          product.description.toLowerCase().contains(keyword);
    }).toList();
  }

  Future<void> _onLoadMoreProductsEvent(
    LoadMoreProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    // scroll listener fires many times, make sure only one request goes out
    if (state.isLoadingMore || state.hasReachedEnd || !state.pageStatus.isSuccess) {
      return;
    }

    final query = state.searchQuery;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    try {
      final skip = state.products.length;
      final response = query.isEmpty
          ? await repository.getProducts(skip: skip)
          : await repository.searchProducts(query, skip: skip);

      if (query != state.searchQuery) return;

      emit(state.copyWith(
        isLoadingMore: false,
        products: [...state.products, ...response.products],
        total: response.total,
      ));
    } catch (ex) {
      if (query != state.searchQuery) return;
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  Future<void> _onSaveRecentSearchEvent(
    SaveRecentSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    final list = await localStorage.addRecentSearch(event.query);
    emit(state.copyWith(recentSearches: list));
  }

  Future<void> _onRemoveRecentSearchEvent(
    RemoveRecentSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    final list = await localStorage.removeRecentSearch(event.query);
    emit(state.copyWith(recentSearches: list));
  }

  Future<void> _onClearRecentSearchesEvent(
    ClearRecentSearchesEvent event,
    Emitter<ProductState> emit,
  ) async {
    await localStorage.clearRecentSearches();
    emit(state.copyWith(recentSearches: const []));
  }

  Future<void> _onToggleFavouriteEvent(
    ToggleFavouriteEvent event,
    Emitter<ProductState> emit,
  ) async {
    // new Set every time, otherwise Equatable sees the same object and skips the rebuild
    final ids = Set<int>.from(state.favouriteIds);
    if (!ids.remove(event.productId)) ids.add(event.productId);

    emit(state.copyWith(favouriteIds: ids));
    await localStorage.saveFavouriteIds(ids);
  }
}
