import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peesha/core/utils/app_constants.dart';
import 'package:peesha/features/employer/data/job_model.dart';
import 'package:peesha/features/employer/data/job_repository.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = JobRepository();
  late Job _job;

  @override
  void initState() {
    super.initState();
    _job = Job(
      title: '',
      description: '',
      requirements: '',
      location: '',
      salary: '',
      jobType: 'Full-time',
      experienceLevel: 'Mid-level',
      employerId: 'temp-id', // Replace with actual employer ID later
      employerName: 'Temp Employer', // Replace with actual name later
      postedDate: DateTime.now(),
      deadline: DateTime.now().add(const Duration(days: 30)),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDeadline) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _job.deadline : _job.postedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _job = _job.copyWith(deadline: picked);
        } else {
          _job = _job.copyWith(postedDate: picked);
        }
      });
    }
  }

  Future<void> _submitJob() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _repository.postJob(_job);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job posted successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error posting job: ${e.toString()}')),
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job title';
                  }
                  return null;
                },
                onSaved: (value) => _job = _job.copyWith(title: value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _job.jobType,
                decoration: const InputDecoration(
                  labelText: 'Job Type',
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.jobTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _job = _job.copyWith(jobType: value!);
                  });
                },
              ),
              // ... rest of your form fields with similar updates ...
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Posted Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_job.postedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              ListTile(
                title: const Text('Application Deadline'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_job.deadline)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitJob,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}