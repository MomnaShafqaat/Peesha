import 'package:flutter/material.dart';

class JobForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController locationController;
  final TextEditingController salaryController;
  final VoidCallback onSave;

  const JobForm({
    super.key,
    required this.titleController,
    required this.descController,
    required this.locationController,
    required this.salaryController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Job Title'),
        ),
        TextField(
          controller: descController,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        TextField(
          controller: locationController,
          decoration: const InputDecoration(labelText: 'Location'),
        ),
        TextField(
          controller: salaryController,
          decoration: const InputDecoration(labelText: 'Salary'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSave,
          child: const Text('Save Job'),
        ),
      ],
    );
  }
}