import '../../../../common_libraries.dart';

/// Swipeable images with page dots at the bottom.
class ProductImageGallery extends StatefulWidget {
  final int productId;
  final List<String> images;

  const ProductImageGallery({super.key, required this.productId, required this.images});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final image = Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.space24,
                  AppDimens.space24,
                  AppDimens.space24,
                  40,
                ),
                child: AppNetworkImage(url: widget.images[index]),
              );

              // only the first image is part of the hero animation from the list
              if (index != 0) return image;
              return Hero(tag: 'product-image-${widget.productId}', child: image);
            },
          ),
          if (widget.images.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.space16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.images.length, (index) {
                  final isActive = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 7,
                    width: isActive ? 22 : 7,
                    decoration: BoxDecoration(
                      color: isActive ? AppColor.primaryColor : AppColor.borderColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
