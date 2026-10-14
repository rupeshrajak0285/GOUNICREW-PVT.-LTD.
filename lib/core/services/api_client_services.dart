import '../../common_libraries.dart';

class ApiClientService {
  static const _timeoutDuration = Duration(seconds: 20);

  late final Dio _dio;

  // Singleton - we only want one Dio instance in the app
  ApiClientService._internal();
  static final ApiClientService _instance = ApiClientService._internal();
  factory ApiClientService() => _instance;

  /// Call this once from main() before runApp
  static Future<void> init() async {
    _instance._dio = _createDio(baseUrl: BaseAPIUrls.baseApiUrl);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  static Dio _createDio({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _timeoutDuration,
        receiveTimeout: _timeoutDuration,
        sendTimeout: _timeoutDuration,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors
      ..clear()
      ..add(AppInterceptor());

    return dio;
  }
}
