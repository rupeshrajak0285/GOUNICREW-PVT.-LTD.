import '../../../../common_libraries.dart';

/// Shown on top of the list when products came from local storage.
class OfflineBanner extends StatelessWidget {
  final DateTime? lastSyncedAt;
  final VoidCallback onRetry;

  const OfflineBanner({super.key, required this.lastSyncedAt, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimens.space16,
        AppDimens.space12,
        AppDimens.space16,
        0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space8,
      ),
      decoration: BoxDecoration(
        color: AppColor.warningColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: AppColor.warningColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 20, color: AppColor.warningColor),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Text(
              "${AppStrings.offlineData} (updated ${AppUtils.timeAgo(lastSyncedAt)})",
              style: const TextStyle(fontSize: 12.5, color: AppColor.blackColor),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
