# Task Manager App - Part 3.1: Logging Interceptor

This branch (`03-1-logging-interceptor`) introduces a basic logging interceptor to the Task Manager app. The logging interceptor logs all HTTP requests and responses, which is useful for debugging and monitoring.

## Overview

In this part, we:
1. Explained what interceptors are and their benefits.
2. Created a basic logging interceptor to log all requests and responses.
3. Added the logging interceptor to Dio.
4. Tested the interceptor by running the app and checking the console logs.

## Steps

### 1. Create a Logging Interceptor

Create a new file `lib/interceptors/logging_interceptor.dart`:

```dart
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log the request method and path
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    // Continue with the request
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log the response status code and path
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    // Continue with the response
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Log the error status code and path
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    // Continue with the error
    super.onError(err, handler);
  }
}
```

### 2. Add the Interceptor to Dio

Modify `lib/services/api_service.dart` to include the logging interceptor:

```dart
import 'package:dio/dio.dart';
import '../models/task.dart';
import '../interceptors/logging_interceptor.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio() {
    // Add the logging interceptor
    _dio.interceptors.add(LoggingInterceptor());
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

Run the app and check the console for logs of requests and responses. You should see logs similar to:

```
REQUEST[GET] => PATH: /todos
RESPONSE[200] => PATH: /todos
```

## Summary

In this part, we:
1. Explained what interceptors are and their benefits.
2. Created a basic logging interceptor to log all requests and responses.
3. Added the logging interceptor to Dio.
4. Tested the interceptor by running the app and checking the console logs.

This sets the foundation for using interceptors in your Task Manager app. Each subsequent tutorial will build on this foundation, adding more complex interceptors and functionality.
