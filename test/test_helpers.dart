import 'package:product_listing_app/common_libraries.dart';

/// Small product list used across tests
List<ProductModel> fakeProducts(int count, {int startId = 1}) {
  return List.generate(
    count,
    (index) => ProductModel(
      id: startId + index,
      title: 'Product ${startId + index}',
      category: 'beauty',
      price: 10.0 + index,
    ),
  );
}

/// Fake repo so tests don't hit the real api.
class FakeProductRepository extends ProductRepository {
  bool shouldFail = false;
  int total = 30;
  final List<String> searchedQueries = [];

  @override
  Future<ProductResponseModel> getProducts({int skip = 0}) async {
    if (shouldFail) throw Exception('No internet');
    final remaining = (total - skip).clamp(0, ProductRepository.pageSize);
    return ProductResponseModel(
      products: fakeProducts(remaining, startId: skip + 1),
      total: total,
      skip: skip,
      limit: ProductRepository.pageSize,
    );
  }

  @override
  Future<ProductResponseModel> searchProducts(String query, {int skip = 0}) async {
    searchedQueries.add(query);
    if (shouldFail) throw Exception('No internet');
    return ProductResponseModel(
      products: [ProductModel(id: 99, title: 'Result for $query')],
      total: 1,
    );
  }
}
