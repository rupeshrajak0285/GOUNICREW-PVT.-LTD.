import '../../../common_libraries.dart';

export 'widgets/widgets.dart';

/// PRODUCT DETAIL SCREEN
/// Product is passed from the list, so no extra api call is needed here.
/// ProductBloc comes from the list page (BlocProvider.value) for the favourite state.
class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  void _toggleFavourite(BuildContext context, bool isFavourite) {
    context.read<ProductBloc>().add(ToggleFavouriteEvent(product.id));
    AppToaster(
      context: context,
      notifyType: isFavourite ? AppNotifyType.info : AppNotifyType.success,
      content: isFavourite ? AppStrings.removedFromFavourite : AppStrings.addedToFavourite,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return BlocSelector<ProductBloc, ProductState, bool>(
      // rebuild only when this product's favourite flag changes
      selector: (state) => state.isFavourite(product.id),
      builder: (context, isFavourite) {
        return Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: screenHeight * 0.42,
                backgroundColor: AppColor.whiteColor,
                surfaceTintColor: Colors.transparent,
                leading: const Padding(
                  padding: EdgeInsets.all(AppDimens.space8),
                  child: _CircleBackButton(),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppDimens.space12),
                    child: FavouriteButton(
                      isFavourite: isFavourite,
                      onTap: () => _toggleFavourite(context, isFavourite),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    bottom: false,
                    child: ProductImageGallery(
                      productId: product.id,
                      images: product.galleryImages,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _infoSection()),
            ],
          ),
          bottomNavigationBar: _bottomBar(context, isFavourite),
        );
      },
    );
  }

  Widget _infoSection() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius20)),
      ),
      padding: const EdgeInsets.all(AppDimens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(AppUtils.prettyCategory(product.category)),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: AppColor.primaryLight,
                side: BorderSide.none,
                visualDensity: VisualDensity.compact,
              ),
              const Spacer(),
              RatingBadge(rating: product.rating, fontSize: 14),
              Text(
                "  (${product.reviews.length} reviews)",
                style: const TextStyle(fontSize: 12, color: AppColor.lightGreyColor),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColor.blackColor,
            ),
          ),
          if (product.brand.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              "by ${product.brand}",
              style: const TextStyle(fontSize: 14, color: AppColor.darkGreyColor),
            ),
          ],
          const SizedBox(height: AppDimens.space12),
          PriceWidget(
            price: product.price,
            discountPercentage: product.discountPercentage,
            large: true,
          ),
          const SizedBox(height: AppDimens.space12),
          StockStatusChip(stock: product.stock),
          const SizedBox(height: AppDimens.space20),
          _sectionTitle(AppStrings.description),
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: AppColor.darkGreyColor,
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          _highlights(),
          if (product.reviews.isNotEmpty) ...[
            const SizedBox(height: AppDimens.space20),
            _sectionTitle(AppStrings.reviews),
            ...product.reviews.map((review) => ReviewCard(review: review)),
          ],
        ],
      ),
    );
  }

  Widget _highlights() {
    // skip the empty ones, some products don't have all the info
    final items = [
      if (product.shippingInformation.isNotEmpty)
        ProductHighlightTile(
          icon: Icons.local_shipping_outlined,
          title: "Shipping",
          value: product.shippingInformation,
        ),
      if (product.warrantyInformation.isNotEmpty)
        ProductHighlightTile(
          icon: Icons.verified_user_outlined,
          title: "Warranty",
          value: product.warrantyInformation,
        ),
      if (product.returnPolicy.isNotEmpty)
        ProductHighlightTile(
          icon: Icons.assignment_return_outlined,
          title: "Return policy",
          value: product.returnPolicy,
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space4,
      ),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(AppDimens.radius16),
      ),
      child: Column(children: items),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColor.blackColor,
        ),
      ),
    );
  }

  Widget _bottomBar(BuildContext context, bool isFavourite) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.space16,
        AppDimens.space12,
        AppDimens.space16,
        AppDimens.space12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        boxShadow: [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price",
                  style: TextStyle(fontSize: 12, color: AppColor.lightGreyColor),
                ),
                Text(
                  AppUtils.formatPrice(product.price),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () => _toggleFavourite(context, isFavourite),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isFavourite ? AppColor.favouriteColor : AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius12),
              ),
            ),
            icon: Icon(
              isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            ),
            label: Text(isFavourite ? "Saved to wishlist" : "Add to wishlist"),
          ),
        ],
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.whiteColor,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_rounded, color: AppColor.blackColor),
      ),
    );
  }
}
