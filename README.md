# Task Manager App - Part 3.2: Headers Interceptor

This branch (`03-2-headers-interceptor`) introduces a headers interceptor to the Task Manager app. The headers interceptor adds common headers to all HTTP requests, ensuring consistency and reducing repetitive code.

## Overview

In this part, we:
1. Explained what headers are and their importance.
2. Created a headers interceptor to add common headers to all requests.
3. Added the headers interceptor to Dio.
4. Tested the interceptor by running the app and checking the request headers.

## Understanding Headers

### What are Headers?
Headers are key-value pairs sent along with HTTP requests and responses. They provide essential information about the request or response, such as the type of content being sent, the length of the content, authentication details, and more.

### Common Types of Headers
1. **Content-Type**: Specifies the media type of the resource. For example, `application/json` indicates that the content is in JSON format.
2. **Authorization**: Contains credentials for authenticating the client with the server. For example, `Bearer YOUR_TOKEN` is used for token-based authentication.
3. **Accept**: Informs the server about the types of data the client can process. For example, `Accept: application/json` indicates that the client expects JSON data.
4. **User-Agent**: Provides information about the client software making the request. For example, `User-Agent: Mozilla/5.0`.
5. **Cache-Control**: Directs caching mechanisms on how to handle the request. For example, `Cache-Control: no-cache` instructs not to cache the response.

### Importance of Headers
1. **Content Negotiation**: Headers like `Content-Type` and `Accept` help in content negotiation between the client and server, ensuring that the data is in a format that both can understand.
2. **Authentication and Security**: Headers such as `Authorization` are crucial for securing API requests and ensuring that only authenticated clients can access certain resources.
3. **Performance Optimization**: Headers like `Cache-Control` can significantly impact the performance of web applications by controlling how responses are cached.
4. **Metadata**: Headers provide additional metadata about the request or response, which can be used for debugging, logging, and monitoring purposes.

## Steps

### 1. Create a Headers Interceptor

Create a new file `lib/interceptors/headers_interceptor.dart`:

```dart
import 'package:dio/dio.dart';

class HeadersInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add common headers to the request
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_TOKEN',
    });
    // Continue with the request
    super.onRequest(options, handler);
  }
}
```

### 2. Add the Interceptor to Dio

Modify `lib/services/api_service.dart` to include the headers interceptor:

```dart
import 'package:dio/dio.dart';
import '../models/task.dart';
import '../interceptors/headers_interceptor.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio() {
    // Add the headers interceptor
    _dio.interceptors.add(HeadersInterceptor());
  }

  Future<List<Task>> fetchTasks() async {
    try {
      // Make a GET request to fetch tasks
      final response = await _dio.get('https://jsonplaceholder.typicode.com/todos');
      // Parse the response data into a list of Task objects
      return (response.data as List).map((task) => Task.fromJson(task)).toList();
    } on DioError catch (dioError) {
      // Handle Dio errors
      if (dioError.type == DioErrorType.connectTimeout) {
        throw Exception('Connection Timeout');
      } else if (dioError.type == DioErrorType.receiveTimeout) {
        throw Exception('Receive Timeout');
      } else if (dioError.type == DioErrorType.response) {
        throw Exception('Received invalid status code: ${dioError.response?.statusCode}');
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

### 3. Test the Interceptor

Run the app and make a request. Check the request headers to ensure the common headers are included.

## Summary

In this part, we:
1. Explained what headers are and their importance.
2. Created a headers interceptor to add common headers to all requests.
3. Added the headers interceptor to Dio.
4. Tested the interceptor by running the app and checking the request headers.

This interceptor ensures that all requests include necessary headers, such as `Content-Type` and `Authorization`, without having to manually add them to each request. This is especially useful for maintaining consistency and reducing repetitive code.
