import '../../common_libraries.dart';

enum AppNotifyType { success, info, error }

/// Small wrapper over SnackBar so every screen shows messages the same way.
class AppToaster {
  final BuildContext context;
  final AppNotifyType notifyType;
  final String content;

  AppToaster({
    required this.context,
    required this.notifyType,
    required this.content,
  });

  void show() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(_icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(content)),
            ],
          ),
          backgroundColor: _color,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppDimens.space16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius12),
          ),
        ),
      );
  }

  Color get _color {
    switch (notifyType) {
      case AppNotifyType.success:
        return AppColor.successColor;
      case AppNotifyType.info:
        return AppColor.darkGreyColor;
      case AppNotifyType.error:
        return AppColor.errorColor;
    }
  }

  IconData get _icon {
    switch (notifyType) {
      case AppNotifyType.success:
        return Icons.check_circle_outline;
      case AppNotifyType.info:
        return Icons.info_outline;
      case AppNotifyType.error:
        return Icons.error_outline;
    }
  }
}
