import 'package:dio/dio.dart';

class ApiService {
  // Create an instance of Dio
  final _dio = Dio();

  // Method to fetch tasks from the API
  Future<List<dynamic>> fetchTasks() async {
    // Make a GET request to the API endpoint
    final response = await _dio.get('https://jsonplaceholder.typicode.com/todos');
    // Return the response data
    return response.data;
  }
}