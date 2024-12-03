# Task Manager App - Part 1: Introduction to Dio

This branch (`01-introduction`) covers the initial setup of Dio in a Flutter project and demonstrates how to make a basic GET request to fetch tasks from a mock API.

## Overview

In this part, we:
1. Created a new Flutter project.
2. Added Dio to the project dependencies.
3. Set up Dio in a service class.
4. Fetched and displayed tasks using Dio.

## Steps

### 1. Create a New Flutter Project

```bash
flutter create task_manager
cd dio_tasker
```

### 2. Add Dio to Your Project

Add Dio to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.0.0
```

Run the following command to install the package:

```bash
flutter pub get
```

### 3. Set Up Dio

Create a new file `lib/services/api_service.dart`:

```dart
import 'package:dio/dio.dart';

class ApiService {
  // Create an instance of Dio
  final Dio _dio = Dio();

  // Method to fetch tasks from the API
  Future<List<dynamic>> fetchTasks() async {
    // Make a GET request to the API endpoint
    final response = await _dio.get('https://jsonplaceholder.typicode.com/todos');
    // Return the response data
    return response.data;
  }
}
```

### 4. Fetch and Display Tasks

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'services/api_service.dart';

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
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the widget is initialized
    _fetchTasks();
  }

  // Method to fetch tasks and update the state
  void _fetchTasks() async {
    // Fetch tasks from the API
    final tasks = await _apiService.fetchTasks();
    // Update the state with the fetched tasks
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: ListView.builder(
        // Set the number of items in the list
        itemCount: _tasks.length,
        // Build each item in the list
        itemBuilder: (context, index) {
          return ListTile(
            // Display the task title
            title: Text(_tasks[index]['title']),
          );
        },
      ),
    );
  }
}
```

