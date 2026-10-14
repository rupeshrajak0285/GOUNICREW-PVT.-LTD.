import '../../../../common_libraries.dart';

/// One row like "Shipping  -  Ships in 1 week".
class ProductHighlightTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProductHighlightTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.space8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.space8),
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              borderRadius: BorderRadius.circular(AppDimens.radius12),
            ),
            child: Icon(icon, size: 20, color: AppColor.primaryColor),
          ),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: AppColor.lightGreyColor),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
