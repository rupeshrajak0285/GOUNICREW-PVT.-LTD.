import '../../../../common_libraries.dart';

/// Grey placeholder cards shown while the first page loads.
/// Feels faster than a single spinner in the middle of the screen.
class ProductGridSkeleton extends StatefulWidget {
  final int itemCount;

  const ProductGridSkeleton({super.key, this.itemCount = 6});

  @override
  State<ProductGridSkeleton> createState() => _ProductGridSkeletonState();
}

class _ProductGridSkeletonState extends State<ProductGridSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.45,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppDimens.space16),
      sliver: SliverGrid.builder(
        gridDelegate: productGridDelegate,
        itemCount: widget.itemCount,
        itemBuilder: (_, _) => FadeTransition(
          opacity: _controller,
          child: const _SkeletonCard(),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(AppDimens.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.shimmerColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimens.radius16),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppDimens.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Line(width: 50),
                SizedBox(height: 8),
                _Line(width: double.infinity),
                SizedBox(height: 6),
                _Line(width: 90),
                SizedBox(height: 14),
                _Line(width: 60, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final double width;
  final double height;

  const _Line({required this.width, this.height = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.shimmerColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Shared by the real grid and the skeleton so both have the same size.
const productGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: AppDimens.productCardMaxWidth,
  mainAxisSpacing: AppDimens.space12,
  crossAxisSpacing: AppDimens.space12,
  mainAxisExtent: 272,
);
