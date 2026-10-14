import '../../../../common_libraries.dart';

/// Green / orange / red chip depending on stock count.
class StockStatusChip extends StatelessWidget {
  final int stock;

  const StockStatusChip({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;

    if (stock <= 0) {
      label = AppStrings.outOfStock;
      color = AppColor.errorColor;
    } else if (stock < 10) {
      label = "${AppStrings.lowStock} · only $stock left";
      color = AppColor.warningColor;
    } else {
      label = "${AppStrings.inStock} · $stock units";
      color = AppColor.successColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.radius20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
