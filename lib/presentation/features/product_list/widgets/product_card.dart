import '../../../../common_libraries.dart';

/// Grid item: image, title, category, price and rating.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavourite,
    required this.onTap,
    required this.onFavouriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.whiteColor,
      borderRadius: BorderRadius.circular(AppDimens.radius16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.space12,
                  AppDimens.space8,
                  AppDimens.space12,
                  AppDimens.space12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppUtils.prettyCategory(product.category),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: AppColor.blackColor,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: PriceWidget(
                            price: product.price,
                            discountPercentage: product.discountPercentage,
                          ),
                        ),
                        RatingBadge(rating: product.rating),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSection() {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColor.shimmerColor,
              padding: const EdgeInsets.all(AppDimens.space8),
              // same tag on detail screen gives the image fly animation
              child: Hero(
                tag: 'product-image-${product.id}',
                child: AppNetworkImage(url: product.thumbnail),
              ),
            ),
          ),
          if (product.hasDiscount)
            Positioned(
              left: AppDimens.space8,
              top: AppDimens.space8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColor.successColor,
                  borderRadius: BorderRadius.circular(AppDimens.radius8),
                ),
                child: Text(
                  "-${product.discountPercentage.round()}%",
                  style: const TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            right: AppDimens.space8,
            top: AppDimens.space8,
            child: FavouriteButton(
              isFavourite: isFavourite,
              onTap: onFavouriteTap,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
