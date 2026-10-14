import '../../common_libraries.dart';

/// Network image with placeholder + error icon.
/// cached_network_image also keeps images on disk, so they load offline too.
class AppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _errorView();

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (_, _) => Container(
        color: AppColor.shimmerColor,
        alignment: Alignment.center,
        child: const CustomLoaderWidget(size: 20, color: AppColor.lightGreyColor),
      ),
      errorWidget: (_, _, _) => _errorView(),
    );
  }

  Widget _errorView() {
    return Container(
      width: width,
      height: height,
      color: AppColor.shimmerColor,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColor.lightGreyColor,
      ),
    );
  }
}
