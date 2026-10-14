import '../../common_libraries.dart';

/// Rounded search box with a clear (x) button.
class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onClear;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.focusNode,
    this.onSubmitted,
    this.hintText = AppStrings.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    // listen to the controller so the clear button shows / hides while typing
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          style: const TextStyle(fontSize: 15, color: AppColor.blackColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColor.lightGreyColor),
            prefixIcon: const Icon(Icons.search_rounded, color: AppColor.darkGreyColor),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close_rounded, color: AppColor.darkGreyColor),
                    onPressed: onClear,
                  ),
            filled: true,
            fillColor: AppColor.whiteColor,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radius16),
              borderSide: const BorderSide(color: AppColor.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radius16),
              borderSide: const BorderSide(color: AppColor.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radius16),
              borderSide: const BorderSide(color: AppColor.primaryColor, width: 1.4),
            ),
          ),
        );
      },
    );
  }
}
