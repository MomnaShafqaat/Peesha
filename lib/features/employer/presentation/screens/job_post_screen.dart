import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peesha/core/utils/app_constants.dart';
import 'package:peesha/features/employer/data/job_model.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  String _jobType = 'Full-time';
  String _experienceLevel = 'Mid-level';
  DateTime _postedDate = DateTime.now();
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  final String _employerId = 'temp-id'; // replace later
  final String _employerName = 'Temp Employer'; // replace later

  Future<void> _selectDate(BuildContext context, bool isDeadline) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _deadline : _postedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _deadline = picked;
        } else {
          _postedDate = picked;
        }
      });
    }
  }
  Future<void> _submitJob() async {
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

      try {
        await FirebaseFirestore.instance.collection('Job').add(job.toJson());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Job posted successfully!')),
          );

          // Wait 1 second before going back to previous screen
          await Future.delayed(const Duration(seconds: 1));

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error posting job: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitJob,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter job title'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter job description'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Salary',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _jobType,
                decoration: const InputDecoration(
                  labelText: 'Job Type',
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.jobTypes
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _jobType = value!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _experienceLevel,
                decoration: const InputDecoration(
                  labelText: 'Experience Level',
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.experienceLevels
                    .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _experienceLevel = value!),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Posted Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_postedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              ListTile(
                title: const Text('Application Deadline'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_deadline)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitJob,
                child: const Text('Post Job'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
