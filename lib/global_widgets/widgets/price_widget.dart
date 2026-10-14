import '../../common_libraries.dart';

/// Shows  $9.99  $12.49  20% OFF
/// [large] is used on the detail screen.
class PriceWidget extends StatelessWidget {
  final double price;
  final double discountPercentage;
  final bool large;

  const PriceWidget({
    super.key,
    required this.price,
    this.discountPercentage = 0,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discountPercentage >= 1;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppDimens.space8,
      runSpacing: 2,
      children: [
        Text(
          AppUtils.formatPrice(price),
          style: TextStyle(
            fontSize: large ? 26 : 16,
            fontWeight: FontWeight.w800,
            color: AppColor.blackColor,
          ),
        ),
        if (hasDiscount) ...[
          Text(
            AppUtils.formatPrice(AppUtils.originalPrice(price, discountPercentage)),
            style: TextStyle(
              fontSize: large ? 15 : 12,
              color: AppColor.lightGreyColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          if (large)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColor.successColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimens.radius8),
              ),
              child: Text(
                "${discountPercentage.round()}% OFF",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColor.successColor,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
