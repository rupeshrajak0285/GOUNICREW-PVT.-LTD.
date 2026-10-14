import '../../../common_libraries.dart';

export 'widgets/widgets.dart';

/// PRODUCT LIST PAGE - home screen of the app.
/// Grid of products with search, pull-to-refresh and infinite scroll.
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        repository: context.read<ProductRepository>(),
        localStorage: context.read<ProductLocalStorage>(),
      ),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatefulWidget {
  const _ProductListView();

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<_ProductListView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _debouncer = Debouncer();

  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchFocusNode.addListener(() {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  ProductBloc get _bloc => context.read<ProductBloc>();

  /// Load next page a bit before the user actually hits the bottom
  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      _bloc.add(LoadMoreProductsEvent());
    }
  }

  Future<void> _onRefresh() async {
    final completer = Completer<void>();
    _bloc.add(FetchProductsEvent(completer: completer));

    try {
      await completer.future;
    } catch (error) {
      if (!mounted) return;
      AppToaster(
        context: context,
        notifyType: AppNotifyType.error,
        content: error.toString(),
      ).show();
    }
  }

  void _onSearchChanged(String text) {
    _debouncer.run(() => _bloc.add(SearchProductsEvent(text)));
  }

  void _onSearchSubmitted(String text) {
    _debouncer.cancel();
    _bloc
      ..add(SearchProductsEvent(text))
      ..add(SaveRecentSearchEvent(text));
  }

  void _onClearSearch() {
    _debouncer.cancel();
    _searchController.clear();
    _bloc.add(SearchProductsEvent(''));
  }

  void _onRecentSearchTap(String keyword) {
    _searchController.text = keyword;
    _searchFocusNode.unfocus();
    _onSearchSubmitted(keyword);
  }

  void _openDetail(ProductModel product) {
    _searchFocusNode.unfocus();

    // user found what they were looking for, so remember this keyword
    final query = _bloc.state.searchQuery;
    if (query.isNotEmpty) _bloc.add(SaveRecentSearchEvent(query));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _bloc,
          child: ProductDetailScreen(product: product),
        ),
      ),
    );
  }

  void _toggleFavourite(ProductModel product) {
    final wasFavourite = _bloc.state.isFavourite(product.id);
    _bloc.add(ToggleFavouriteEvent(product.id));

    AppToaster(
      context: context,
      notifyType: wasFavourite ? AppNotifyType.info : AppNotifyType.success,
      content: wasFavourite ? AppStrings.removedFromFavourite : AppStrings.addedToFavourite,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // tap outside closes the keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColor.primaryColor,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  _appBar(state),
                  if (_isSearchFocused &&
                      _searchController.text.isEmpty &&
                      state.recentSearches.isNotEmpty)
                    SliverToBoxAdapter(
                      child: RecentSearchSection(
                        searches: state.recentSearches,
                        onTap: _onRecentSearchTap,
                        onRemove: (keyword) =>
                            _bloc.add(RemoveRecentSearchEvent(keyword)),
                        onClearAll: () => _bloc.add(ClearRecentSearchesEvent()),
                      ),
                    ),
                  if (state.isOfflineData && state.pageStatus.isSuccess)
                    SliverToBoxAdapter(
                      child: OfflineBanner(
                        lastSyncedAt: state.lastSyncedAt,
                        onRetry: () => _bloc.add(FetchProductsEvent()),
                      ),
                    ),
                  ..._content(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _appBar(ProductState state) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColor.backgroundColor,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
      // web / iOS center the title by default, we want it on the left
      centerTitle: false,
      titleSpacing: AppDimens.space16,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColor.blackColor,
            ),
          ),
          Text(
            "Find something you'll love",
            style: TextStyle(fontSize: 13, color: AppColor.darkGreyColor),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppDimens.space12),
          child: Badge(
            isLabelVisible: state.favouriteIds.isNotEmpty,
            label: Text("${state.favouriteIds.length}"),
            backgroundColor: AppColor.favouriteColor,
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColor.favouriteColor,
              size: 26,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.space16,
            0,
            AppDimens.space16,
            AppDimens.space12,
          ),
          child: AppSearchField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
            onClear: _onClearSearch,
          ),
        ),
      ),
    );
  }

  /// Main body slivers based on the current page status
  List<Widget> _content(ProductState state) {
    if (state.pageStatus.isInitial || state.pageStatus.isLoading) {
      return [const ProductGridSkeleton()];
    }

    if (state.pageStatus.isFailure) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: AppMessageView(
              icon: Icons.wifi_off_rounded,
              iconColor: AppColor.errorColor,
              title: AppStrings.somethingWentWrong,
              message: state.errorMessage,
              actionLabel: AppStrings.tryAgain,
              onAction: () => _bloc.add(FetchProductsEvent()),
            ),
          ),
        ),
      ];
    }

    if (state.products.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: AppMessageView(
              icon: Icons.search_off_rounded,
              title: AppStrings.noProductsFound,
              message: state.isSearching
                  ? 'Nothing matched "${state.searchQuery}". ${AppStrings.noProductsFoundDesc}'
                  : AppStrings.noProductsFoundDesc,
            ),
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(child: _resultHeader(state)),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.space16,
          AppDimens.space8,
          AppDimens.space16,
          AppDimens.space16,
        ),
        sliver: SliverGrid.builder(
          gridDelegate: productGridDelegate,
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ProductCard(
              product: product,
              isFavourite: state.isFavourite(product.id),
              onTap: () => _openDetail(product),
              onFavouriteTap: () => _toggleFavourite(product),
            );
          },
        ),
      ),
      SliverToBoxAdapter(
        child: ProductListFooter(
          isLoadingMore: state.isLoadingMore,
          loadMoreFailed: state.loadMoreFailed,
          hasReachedEnd: state.hasReachedEnd,
          onRetry: () => _bloc.add(LoadMoreProductsEvent()),
        ),
      ),
    ];
  }

  Widget _resultHeader(ProductState state) {
    final title = state.isSearching ? 'Results for "${state.searchQuery}"' : 'All products';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.space16,
        AppDimens.space16,
        AppDimens.space16,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.blackColor,
              ),
            ),
          ),
          Text(
            "${state.total} ${state.total == 1 ? 'item' : 'items'}",
            style: const TextStyle(fontSize: 13, color: AppColor.darkGreyColor),
          ),
        ],
      ),
    );
  }
}
