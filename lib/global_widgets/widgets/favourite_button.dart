import '../../common_libraries.dart';

/// Heart button with a small scale animation when it changes.
class FavouriteButton extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onTap;
  final double size;

  const FavouriteButton({
    super.key,
    required this.isFavourite,
    required this.onTap,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.whiteColor,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              // key is needed so AnimatedSwitcher knows the icon changed
              key: ValueKey(isFavourite),
              size: size,
              color: isFavourite ? AppColor.favouriteColor : AppColor.darkGreyColor,
            ),
          ),
        ),
      ),
    );
  }
}
