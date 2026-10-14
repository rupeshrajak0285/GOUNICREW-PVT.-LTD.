import '../../common_libraries.dart';

/// Common loader, used for pagination footer and anywhere we need a spinner.
class CustomLoaderWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color color;

  const CustomLoaderWidget({
    super.key,
    this.message,
    this.size = 28,
    this.color = AppColor.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.6,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppDimens.space12),
          Text(
            message!,
            style: const TextStyle(
              color: AppColor.darkGreyColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
