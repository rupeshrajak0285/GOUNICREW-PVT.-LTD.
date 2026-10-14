class BaseAPIUrls {
  // DummyJSON is a free fake REST api, no auth needed.
  static const String baseApiUrl = "https://dummyjson.com";

  // Endpoints
  static const String products = "/products";
  static const String searchProducts = "/products/search";
  static String productDetail(int id) => "/products/$id";
}
