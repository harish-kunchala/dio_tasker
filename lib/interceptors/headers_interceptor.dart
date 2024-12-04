import 'package:dio/dio.dart';

class HeadersInterceptor extends Interceptor {

  /// onRequest: This method is called before a request is sent.
  /// We add common headers such as `Content-Type` and `Authorization` to the request options.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add common headers to the request.
    options.headers.addAll({
      'Content-Type': 'application/json',
    });


    // Continue with the request.
    super.onRequest(options, handler);
  }
}