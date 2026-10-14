import 'package:dio/dio.dart';

// toString() of each class is what we show to the user,
// so keep the messages short and simple.

class DeadLineExceededException extends DioException {
  DeadLineExceededException({required super.requestOptions, super.response});

  @override
  String toString() => 'The request timed out. Please try again.';
}

class BadRequestException extends DioException {
  BadRequestException({required super.requestOptions, super.response});

  @override
  String toString() {
    // DummyJSON sends {"message": "..."} on errors
    final data = response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return 'Invalid request. Please try again.';
  }
}

class NotFoundException extends DioException {
  NotFoundException({required super.requestOptions, super.response});

  @override
  String toString() => 'The requested item was not found.';
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException({required super.requestOptions, super.response});

  @override
  String toString() => 'Something went wrong on the server. Please try again later.';
}

class ServerErrorException extends DioException {
  ServerErrorException({required super.requestOptions, super.response});

  @override
  String toString() => 'Server is currently unavailable. Please try again later.';
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException({required super.requestOptions, super.response});

  @override
  String toString() => 'No internet connection. Please check your network.';
}
