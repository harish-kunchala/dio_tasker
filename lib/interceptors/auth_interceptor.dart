import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Check if the Authorization header is already present
    // Check if the Authorization header is already present
    if (!options.headers.containsKey('Authorization')) {
      // Add the access token to the headers
      const token = 'YOUR_ACCESS_TOKEN';
      print('Adding Authorization header with token: $token');
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh logic
      final newToken = await _refreshToken();
      if (newToken != null) {
        // Retry the request with the new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';
        final response = await dio.request(
          options.path,
          options: Options(
            method: options.method,
            headers: options.headers,
          ),
        );
        return handler.resolve(response);
      }
    }
    return super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    // Implement your token refresh logic here
    // For example, make a request to refresh the token
    // and return the new token
    return 'NEW_ACCESS_TOKEN';
  }
}