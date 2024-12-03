
# Task Manager App - Part 2: Handling Responses and Errors


This branch (`02-handling-responses-errors`) enhances the Task Manager app by parsing JSON responses and handling different types of errors using Dio.

## Overview

In this part, we:
1. Created a `Task` model to parse JSON responses.
2. Updated `ApiService` to handle different types of errors.
3. Modified the UI to display error messages.

## Steps

### 1. Create a Task Model

Create a new file `lib/models/task.dart`:

```dart
class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, required this.completed});

  // Factory method to create a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
```

### 2. Update ApiService to Handle Errors

Modify `lib/services/api_service.dart`:

```dart
import 'package:dio/dio.dart';
import '../models/task.dart';

class ApiService {
  // Create an instance of Dio
  final Dio _dio = Dio();

  // Method to fetch tasks from the API
  Future<List<Task>> fetchTasks() async {
    try {
      // Make a GET request to the API endpoint
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

### 3. Update UI to Display Errors

Modify `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Create an instance of ApiService
  final ApiService _apiService = ApiService();
  // List to hold the fetched tasks
  List<Task> _tasks = [];
  // Variable to hold error messages
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the widget is initialized
    _fetchTasks();
  }

  // Method to fetch tasks and update the state
  void _fetchTasks() async {
    try {
      // Fetch tasks from the API
      final tasks = await _apiService.fetchTasks();
      // Update the state with the fetched tasks
      setState(() {
        _tasks = tasks;
        _errorMessage = null;
      });
    } catch (e) {
      // Update the state with the error message
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : ListView.builder(
              // Set the number of items in the list
              itemCount: _tasks.length,
              // Build each item in the list
              itemBuilder: (context, index) {
                return ListTile(
                  // Display the task title
                  title: Text(_tasks[index].title),
                );
              },
            ),
    );
  }
}
```

## Summary

In this part, we enhanced the Task Manager app by:
1. Creating a `Task` model to parse JSON responses.
2. Updating `ApiService` to handle different types of errors.
3. Modifying the UI to display error messages.

This ensures that our app can gracefully handle errors and display meaningful messages to the user.

