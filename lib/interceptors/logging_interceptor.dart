import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {

  /// onRequest: This method is called before a request is sent.
  /// We log the HTTP method (GET, POST, etc.) and the request path.
  /// We log the HTTP request headers
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log the request method and path.
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    // Log the request header
    print('REQUEST HEADER[${options.headers.toString()}]');
    // Continue with the request.
    super.onRequest(options, handler);
  }

  /// onResponse: This method is called when a response is received.
  /// We log the status code and the request path.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log the response status code and path.
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    // Continue with the response.
    super.onResponse(response, handler);
  }

  /// onError: This method is called when an error occurs.
  /// We log the error status code (if available) and the request path.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log the error status code and path.
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    // Continue with the error.
    super.onError(err, handler);
  }
}
