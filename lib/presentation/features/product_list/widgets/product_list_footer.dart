import '../../../../common_libraries.dart';

/// Bottom of the grid: loader while fetching next page,
/// retry text if it failed, or a small "end" message.
class ProductListFooter extends StatelessWidget {
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final bool hasReachedEnd;
  final VoidCallback onRetry;

  const ProductListFooter({
    super.key,
    required this.isLoadingMore,
    required this.loadMoreFailed,
    required this.hasReachedEnd,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isLoadingMore) {
      child = const CustomLoaderWidget(size: 24);
    } else if (loadMoreFailed) {
      child = TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text(AppStrings.loadMoreFailed),
      );
    } else if (hasReachedEnd) {
      child = const Text(
        AppStrings.endOfList,
        style: TextStyle(color: AppColor.lightGreyColor, fontSize: 13),
      );
    } else {
      child = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space24),
      child: Center(child: child),
    );
  }
}
