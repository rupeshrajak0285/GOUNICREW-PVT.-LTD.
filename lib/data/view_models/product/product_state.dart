part of 'product_bloc.dart';

class ProductState extends Equatable {
  /// Status of the first page load (full screen loader / error)
  final PageStatus pageStatus;
  final List<ProductModel> products;

  /// Total products available on server for current list / search
  final int total;
  final String searchQuery;

  /// Pagination flags, kept apart from pageStatus so the grid
  /// doesn't get replaced by a loader while loading the next page.
  final bool isLoadingMore;
  final bool loadMoreFailed;

  /// True when api failed and we are showing products from local storage
  final bool isOfflineData;
  final DateTime? lastSyncedAt;

  final String errorMessage;
  final List<String> recentSearches;
  final Set<int> favouriteIds;

  const ProductState({
    this.pageStatus = PageStatus.initial,
    this.products = const [],
    this.total = 0,
    this.searchQuery = '',
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.isOfflineData = false,
    this.lastSyncedAt,
    this.errorMessage = '',
    this.recentSearches = const [],
    this.favouriteIds = const {},
  });

  bool get isSearching => searchQuery.isNotEmpty;

  // cached data has no "next page", so stop pagination when offline
  bool get hasReachedEnd => isOfflineData || products.length >= total;

  bool isFavourite(int productId) => favouriteIds.contains(productId);

  @override
  List<Object?> get props => [
        pageStatus,
        products,
        total,
        searchQuery,
        isLoadingMore,
        loadMoreFailed,
        isOfflineData,
        lastSyncedAt,
        errorMessage,
        recentSearches,
        favouriteIds,
      ];

  ProductState copyWith({
    PageStatus? pageStatus,
    List<ProductModel>? products,
    int? total,
    String? searchQuery,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    bool? isOfflineData,
    DateTime? lastSyncedAt,
    String? errorMessage,
    List<String>? recentSearches,
    Set<int>? favouriteIds,
  }) {
    return ProductState(
      pageStatus: pageStatus ?? this.pageStatus,
      products: products ?? this.products,
      total: total ?? this.total,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      isOfflineData: isOfflineData ?? this.isOfflineData,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      recentSearches: recentSearches ?? this.recentSearches,
      favouriteIds: favouriteIds ?? this.favouriteIds,
    );
  }
}
