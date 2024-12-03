import 'package:dio/dio.dart';
import 'package:dio_tasker/interceptors/headers_interceptor.dart';
import 'package:dio_tasker/interceptors/logging_interceptor.dart';

import '../models/tasks.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio() {
    // Add the logging interceptor
    _dio.interceptors.add(LoggingInterceptor());

    // Add the headers interceptor.
    _dio.interceptors.add(HeadersInterceptor());
  }

  // Method to fetch tasks from the API
  Future<List<Task>> fetchTasks() async {
    try {
      // Make a GET request to fetch tasks
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/todos');
      // Parse the response data into a list of Task objects
      return (response.data as List)
          .map((task) => Task.fromJSON(task))
          .toList();
    } on DioException catch (dioException) {
      // Handle Dio Exceptions
      if (dioException.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection Timeout');
      } else if (dioException.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive Timeout');
      } else if (dioException.type == DioExceptionType.badResponse) {
        throw Exception(
            'Received invalid status code: ${dioException.response?.statusCode}');
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      // Handle other errors
      throw Exception('Failed to load tasks');
    }
  }
}
