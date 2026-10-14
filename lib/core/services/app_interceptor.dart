import '../../common_libraries.dart';

/// Logs request / response in debug mode and converts dio errors
/// into our own exceptions so the UI gets a readable message.
class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['accept'] = 'application/json';

    if (kDebugMode) {
      debugPrint("---------- API REQUEST ----------");
      debugPrint("URL    : ${options.uri}");
      debugPrint("METHOD : ${options.method}");
      if (options.method != "GET") debugPrint("BODY   : ${options.data}");
      debugPrint("---------------------------------");
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      // Not printing the full body here, product list is huge and floods the console
      debugPrint("---------- API RESPONSE ---------");
      debugPrint("URL    : ${response.requestOptions.uri}");
      debugPrint("STATUS : ${response.statusCode}");
      debugPrint("---------------------------------");
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint("----------- API ERROR -----------");
      debugPrint("URL     : ${err.requestOptions.uri}");
      debugPrint("TYPE    : ${err.type}");
      debugPrint("STATUS  : ${err.response?.statusCode}");
      debugPrint("MESSAGE : ${err.message}");
      debugPrint("---------------------------------");
    }

    DioException customError;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        customError = DeadLineExceededException(
          requestOptions: err.requestOptions,
          response: err.response,
        );
        break;

      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            customError = BadRequestException(
              requestOptions: err.requestOptions,
              response: err.response,
            );
            break;
          case 404:
            customError = NotFoundException(
              requestOptions: err.requestOptions,
              response: err.response,
            );
            break;
          case 500:
            customError = InternalServerErrorException(
              requestOptions: err.requestOptions,
              response: err.response,
            );
            break;
          default:
            customError = ServerErrorException(
              requestOptions: err.requestOptions,
              response: err.response,
            );
        }
        break;

      // connectionError comes when there is no network (or DNS fails)
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        customError = NoInternetConnectionException(
          requestOptions: err.requestOptions,
          response: err.response,
        );
        break;

      default:
        customError = err;
    }

    handler.reject(customError);
  }
}
