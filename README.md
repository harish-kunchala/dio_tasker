### Adding Authorization Header Dynamically

1. **Modify the Authentication Interceptor**:
   - Update `lib/interceptors/auth_interceptor.dart` to check if the `Authorization` header is already present and add it if it's missing:
     ```dart
     import 'package:dio/dio.dart';

     class AuthInterceptor extends Interceptor {
       final Dio dio;
       AuthInterceptor(this.dio);

       @override
       void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
         // Check if the Authorization header is already present
         if (!options.headers.containsKey('Authorization')) {
           // Add the access token to the headers
           options.headers['Authorization'] = 'Bearer YOUR_ACCESS_TOKEN';
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
     ```

   **Explanation**:
   - **onRequest**: Before sending the request, we check if the `Authorization` header is already present. If it's not, we add the `Authorization` header with the access token.
   - **onError**: If a 401 error occurs, we attempt to refresh the token and retry the request with the new token.

2. **Add the Interceptor to Dio**:
   - Modify `lib/services/api_service.dart` to include the updated authentication interceptor:
     ```dart
     import 'package:dio/dio.dart';
     import '../models/task.dart';
     import '../interceptors/auth_interceptor.dart';

     class ApiService {
       final Dio _dio;

       ApiService() : _dio = Dio() {
         // Add the authentication interceptor
         _dio.interceptors.add(AuthInterceptor(_dio));
       }

       Future<List<Task>> fetchTasks() async {
         try {
           // Make a GET request to fetch tasks
           final response = await _dio.get('https://jsonplaceholder.typicode.com/todos');
           // Parse the response data into a list of Task objects
           return (response.data as List).map((task) => Task.fromJson(task)).toList();
         } on DioException catch (dioException) {
           // Handle Dio exceptions
           if (dioException.type == DioExceptionType.connectionTimeout) {
             throw Exception('Connection Timeout');
           } else if (dioException.type == DioExceptionType.receiveTimeout) {
             throw Exception('Receive Timeout');
           } else if (dioException.type == DioExceptionType.badResponse) {
             throw Exception('Received invalid status code: ${dioException.response?.statusCode}');
           } else {
             throw Exception('Something went wrong');
           }
         } catch (e) {
           // Handle other errors
           throw Exception('Failed to load tasks');
         }
       }
     }
     ```

   **Explanation**:
   - We import the updated `AuthInterceptor` and add it to the Dio instance using `_dio.interceptors.add(AuthInterceptor(_dio))`.
   - The `fetchTasks` method remains the same, making a GET request to fetch tasks and handling errors.

3. **Test the Interceptor**:
   - Run the app and make a request that requires authentication. Check if the `Authorization` header is dynamically added to the request headers and if the token refresh logic works when a 401 error occurs.


### Summary
In this tutorial, we:
1. Explained token-based authentication and authentication headers.
2. Created an authentication interceptor to handle token-based authentication and refresh tokens automatically.
3. Modified the interceptor to dynamically add the `Authorization` header if it's missing.
4. Added the authentication interceptor to Dio.
5. Tested the interceptor by running the app and checking if the `Authorization` header is dynamically added and if the token refresh logic works.

This interceptor ensures that all requests include the necessary authentication token and handles token refresh automatically, improving the security and user experience of your app.