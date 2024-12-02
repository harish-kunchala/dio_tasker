import 'package:dio_tasker/services/api_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
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
        title: const Text('Task Manager'),
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
