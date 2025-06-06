import 'package:flutter/material.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posted Jobs')),
      body: ListView.builder(
        itemCount: 5, // Replace with actual job count
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text('Job Title ${index + 1}'),
            subtitle: Text('Location ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}