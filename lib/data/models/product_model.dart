import '../../common_libraries.dart';

/// Single product from DummyJSON.
/// Only keeping the fields we actually use in the UI.
class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final String returnPolicy;
  final String thumbnail;
  final List<String> images;
  final List<String> tags;
  final List<ReviewModel> reviews;

  const ProductModel({
    required this.id,
    required this.title,
    this.description = '',
    this.category = '',
    this.price = 0,
    this.discountPercentage = 0,
    this.rating = 0,
    this.stock = 0,
    this.brand = '',
    this.warrantyInformation = '',
    this.shippingInformation = '',
    this.availabilityStatus = '',
    this.returnPolicy = '',
    this.thumbnail = '',
    this.images = const [],
    this.tags = const [],
    this.reviews = const [],
  });

  /// Price before discount, used for the strike-through text.
  double get originalPrice => AppUtils.originalPrice(price, discountPercentage);

  bool get hasDiscount => discountPercentage >= 1;

  /// Detail page slider needs at least one image, fall back to thumbnail.
  List<String> get galleryImages => images.isNotEmpty ? images : [thumbnail];

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      // api sometimes sends int (e.g. 10) and sometimes double (9.99)
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? '',
      warrantyInformation: json['warrantyInformation'] ?? '',
      shippingInformation: json['shippingInformation'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      returnPolicy: json['returnPolicy'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? const []),
      tags: List<String>.from(json['tags'] ?? const []),
      reviews: (json['reviews'] as List? ?? const [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
    );
  }

  /// Needed for saving products in local storage (offline cache).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'returnPolicy': returnPolicy,
      'thumbnail': thumbnail,
      'images': images,
      'tags': tags,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, title, price, stock, thumbnail];
}

class ReviewModel extends Equatable {
  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime? date;

  const ReviewModel({
    this.rating = 0,
    this.comment = '',
    this.reviewerName = '',
    this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'reviewerName': reviewerName,
      'date': date?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [rating, comment, reviewerName, date];
}
