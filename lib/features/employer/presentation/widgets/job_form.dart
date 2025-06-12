import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:peesha/features/employer/data/job_model.dart';
import 'package:peesha/core/utils/app_constants.dart';

class JobForm extends StatefulWidget {
  final VoidCallback onJobPosted;
  const JobForm({super.key, required this.onJobPosted});

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();

  String _jobType = 'Full-time';
  String _experienceLevel = 'Mid-level';
  DateTime _postedDate = DateTime.now();
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  final String _employerId = 'temp-id';
  final String _employerName = 'Temp Employer';

  void _submitJob() async {
    if (_formKey.currentState!.validate()) {
      final job = Job(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        salary: _salaryController.text.trim(),
        jobType: _jobType,
        experienceLevel: _experienceLevel,
        employerId: _employerId,
        employerName: _employerName,
        datePosted: DateFormat('yyyy-MM-dd').format(_postedDate),
        dateDeadline: DateFormat('yyyy-MM-dd').format(_deadline),
      );

      await FirebaseFirestore.instance.collection('Job').add(job.toJson());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Job Posted!')),
        );
        widget.onJobPosted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Job Title'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _jobType,
              onChanged: (val) => setState(() => _jobType = val!),
              items: AppConstants.jobTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Job Type'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _experienceLevel,
              onChanged: (val) => setState(() => _experienceLevel = val!),
              items: AppConstants.experienceLevels
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Experience Level'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _submitJob, child: const Text('Post Job')),
          ],
        ),
      ),
    );
  }
}
