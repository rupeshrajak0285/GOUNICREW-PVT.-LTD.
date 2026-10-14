import '../../../../common_libraries.dart';

/// Chips of the last few searches (saved in local storage).
class RecentSearchSection extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const RecentSearchSection({
    super.key,
    required this.searches,
    required this.onTap,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.space16,
        AppDimens.space12,
        AppDimens.space16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, size: 18, color: AppColor.darkGreyColor),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  AppStrings.recentSearches,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(AppStrings.clearAll),
              ),
            ],
          ),
          Wrap(
            spacing: AppDimens.space8,
            runSpacing: AppDimens.space8,
            children: searches
                .map(
                  (keyword) => InputChip(
                    label: Text(keyword),
                    onPressed: () => onTap(keyword),
                    onDeleted: () => onRemove(keyword),
                    deleteIcon: const Icon(Icons.close_rounded, size: 16),
                    backgroundColor: AppColor.whiteColor,
                    side: const BorderSide(color: AppColor.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radius20),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
