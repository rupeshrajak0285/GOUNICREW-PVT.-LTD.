import '../../common_libraries.dart';

class AppUtils {
  AppUtils._();

  /// 12.5 -> "$12.50"
  static String formatPrice(num price) => "\$${price.toStringAsFixed(2)}";

  /// DummyJSON gives the discounted price only, so we work out the
  /// original (MRP) price from the discount percentage.
  static double originalPrice(double price, double discountPercentage) {
    if (discountPercentage <= 0 || discountPercentage >= 100) return price;
    return price / (1 - discountPercentage / 100);
  }

  /// "beauty" -> "Beauty", "mens-shirts" -> "Mens Shirts"
  static String prettyCategory(String category) {
    return category
        .split('-')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Used for the "last updated" text when we show cached data.
  static String timeAgo(DateTime? time) {
    if (time == null) return "some time ago";

    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
  }

  /// Turns any exception into a message we can show on screen.
  static String errorMessage(Object error) {
    if (error is DioException) {
      // our custom exceptions override toString()
      final message = error.toString();
      if (!message.startsWith('DioException')) return message;
      return 'Something went wrong. Please try again.';
    }
    if (error is FormatException) {
      return 'Received invalid data from server.';
    }
    return error.toString().replaceFirst('Exception: ', '');
  }
}
