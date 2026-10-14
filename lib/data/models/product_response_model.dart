import '../../common_libraries.dart';

/// Wrapper of the list api:
/// { "products": [...], "total": 194, "skip": 0, "limit": 20 }
class ProductResponseModel extends Equatable {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductResponseModel({
    this.products = const [],
    this.total = 0,
    this.skip = 0,
    this.limit = 0,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      products: (json['products'] as List? ?? const [])
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}
