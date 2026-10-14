import '../../../../common_libraries.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final initial = review.reviewerName.isNotEmpty ? review.reviewerName[0] : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.space12),
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColor.primaryLight,
                child: Text(
                  initial.toUpperCase(),
                  style: const TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.space8),
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              // filled stars for rating, outlined for the rest
              ...List.generate(
                5,
                (index) => Icon(
                  index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 16,
                  color: AppColor.ratingColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 13.5, color: AppColor.darkGreyColor),
          ),
        ],
      ),
    );
  }
}
