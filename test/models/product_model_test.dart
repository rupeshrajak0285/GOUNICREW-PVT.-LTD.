import 'package:flutter_test/flutter_test.dart';
import 'package:product_listing_app/common_libraries.dart';

void main() {
  group('ProductModel', () {
    final json = {
      'id': 1,
      'title': 'Essence Mascara',
      'category': 'beauty',
      'price': 10, // int on purpose, api does this sometimes
      'discountPercentage': 20,
      'rating': 4.94,
      'stock': 5,
      'thumbnail': 'thumb.png',
      'images': ['a.png', 'b.png'],
      'reviews': [
        {'rating': 5, 'comment': 'Great', 'reviewerName': 'Asha', 'date': '2024-05-23T08:56:21.618Z'},
      ],
    };

    test('parses json and handles int price', () {
      final product = ProductModel.fromJson(json);

      expect(product.id, 1);
      expect(product.price, 10.0);
      expect(product.images.length, 2);
      expect(product.reviews.first.reviewerName, 'Asha');
      expect(product.brand, ''); // missing field falls back to empty
    });

    test('original price is calculated from discount', () {
      final product = ProductModel.fromJson(json);
      expect(product.originalPrice, closeTo(12.5, 0.001));
      expect(product.hasDiscount, isTrue);
    });

    test('toJson -> fromJson gives the same product (used by offline cache)', () {
      final product = ProductModel.fromJson(json);
      final copy = ProductModel.fromJson(product.toJson());
      expect(copy, product);
      expect(copy.reviews, product.reviews);
    });

    test('gallery falls back to thumbnail when there are no images', () {
      const product = ProductModel(id: 2, title: 'x', thumbnail: 'thumb.png');
      expect(product.galleryImages, ['thumb.png']);
    });
  });

  test('AppUtils.prettyCategory', () {
    expect(AppUtils.prettyCategory('mens-shirts'), 'Mens Shirts');
  });
}
