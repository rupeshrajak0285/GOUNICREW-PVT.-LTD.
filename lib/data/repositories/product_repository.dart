import '../../common_libraries.dart';

class ProductRepository extends BaseRepository {
  /// How many products we load per page
  static const int pageSize = 20;

  // Only ask for the fields we need, keeps the response small
  static const String _selectFields =
      'title,description,category,price,discountPercentage,rating,stock,brand,'
      'warrantyInformation,shippingInformation,availabilityStatus,returnPolicy,'
      'thumbnail,images,tags,reviews';

  /// Paginated product list
  Future<ProductResponseModel> getProducts({int skip = 0}) async {
    try {
      final response = await getRequest(
        BaseAPIUrls.products,
        queryParams: {
          'limit': pageSize,
          'skip': skip,
          'select': _selectFields,
        },
      );
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Search by keyword, DummyJSON matches it with title / description
  Future<ProductResponseModel> searchProducts(String query, {int skip = 0}) async {
    try {
      final response = await getRequest(
        BaseAPIUrls.searchProducts,
        queryParams: {
          'q': query,
          'limit': pageSize,
          'skip': skip,
          'select': _selectFields,
        },
      );
      return _parseResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  ProductResponseModel _parseResponse(Response response) {
    if (response.statusCode != 200 || response.data == null) {
      throw Exception("Fetching products failed with status: ${response.statusCode}");
    }

    final dynamic decoded =
        response.data is String ? jsonDecode(response.data) : response.data;

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException("Unexpected response format");
    }

    return ProductResponseModel.fromJson(decoded);
  }
}
