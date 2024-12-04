import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {

  /// onError: This method is called when an error occurs.
  /// We determine the type of error and set a user-friendly error message.
  /// The error message is then printed, and the error is passed to the next handler using super.onError.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;
    if (err.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection Timeout';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Receive Timeout';
    } else if (err.type == DioExceptionType.badResponse) {
      errorMessage =
          'Received invalid status code: ${err.response?.statusCode}';
    } else if (err.type == DioExceptionType.connectionError) {
      errorMessage = 'Connection Error';
    } else {
      errorMessage = 'Something went wrong';
    }
    // Show a user-friendly error message.
    print('Error: $errorMessage');
    // Pass the error to the next handler.
    super.onError(err, handler);
  }
}
