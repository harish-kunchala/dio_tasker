import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;

  RetryInterceptor(this.dio);

  /// onError: This method is called when an error occurs.
  /// We check if the request should be retried using the _shouldRetry method. If it should, we retry the request.
  /// If the retry fails, we call super.onError to pass the error to the next handler. If no retry is needed, we also call super.onError.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the request should be retried
    if (_shouldRetry(err)) {
      try {
        // Retry the request
        final response = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
        );

        // Resolve the response
        return handler.resolve(response);
      } catch (e) {
        // If the retry fails, pass the error to the next handler.
        return handler.next(err);
      }
    }
    // If no retry, pass the error to the next handler.
    super.onError(err, handler);
  }

  // Determine if the request should be retried.
  bool _shouldRetry(DioException exception) {
    return exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.badResponse;
  }
}
