import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peesha/features/employer/data/job_model.dart';
import 'package:peesha/core/utils/app_constants.dart';
import 'package:peesha/features/employer/presentation/screens/employer_profile_screen.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProfileComplete = false;
  bool _isLoading = true;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();

  String _jobType = 'Full-time';
  String _experienceLevel = 'Mid-level';
  DateTime _postedDate = DateTime.now();
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  final String _employerId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String _employerName = 'Temp Employer';

  bool _showForm = false;

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _salaryController.clear();
    _jobType = 'Full-time';
    _experienceLevel = 'Mid-level';
    _postedDate = DateTime.now();
    _deadline = DateTime.now().add(const Duration(days: 30));
  }

  Future<void> _selectDate(BuildContext context, bool isDeadline) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _deadline : _postedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
            const SnackBar(content: Text('✅ Job posted successfully')),
          );
          setState(() {
            _showForm = false;
            _clearForm();
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkEmployerProfile();
  }

  Future<void> _checkEmployerProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('employerProfiles').doc(uid).get();
    final profile = doc.data();

    setState(() {
      _isProfileComplete = doc.exists;
      _employerName = profile?['companyName'] ?? 'Temp Employer';
      _isLoading = false;
    });
  }

  Widget _buildJobForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Job Title'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _jobType,
              decoration: const InputDecoration(labelText: 'Job Type'),
              items: AppConstants.jobTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => _jobType = val!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _experienceLevel,
              decoration: const InputDecoration(labelText: 'Experience Level'),
              items: AppConstants.experienceLevels
                  .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                  .toList(),
              onChanged: (val) => setState(() => _experienceLevel = val!),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Posted Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_postedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            ListTile(
              title: const Text('Deadline'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_deadline)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitJob,
              child: const Text('Post Job'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Job')
          .where('employerId', isEqualTo: _employerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No jobs posted yet.'));
        }

        final jobs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final doc = jobs[index];
            final job = Job.fromJson(doc.data() as Map<String, dynamic>, doc.id);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(job.title),
                subtitle: Text('${job.location} • ${job.jobType}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          _titleController.text = job.title;
                          _descriptionController.text = job.description;
                          _locationController.text = job.location;
                          _salaryController.text = job.salary;
                          _jobType = job.jobType;
                          _experienceLevel = job.experienceLevel;
                          _postedDate = DateFormat('yyyy-MM-dd').parse(job.datePosted);
                          _deadline = DateFormat('yyyy-MM-dd').parse(job.dateDeadline);
                          _showForm = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Job'),
                            content: const Text('Are you sure you want to delete this job?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await FirebaseFirestore.instance.collection('Job').doc(doc.id).delete();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfilePrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "You need to complete your company profile before posting jobs.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployerProfileScreen()),
                );
              },
              icon: const Icon(Icons.business),
              label: const Text("Setup Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Posted Jobs')),
      floatingActionButton: _isProfileComplete
          ? FloatingActionButton(
        child: Icon(_showForm ? Icons.close : Icons.add),
        onPressed: () {
          setState(() {
            _showForm = !_showForm;
            if (!_showForm) _clearForm();
          });
        },
      )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isProfileComplete
          ? (_showForm ? _buildJobForm() : _buildJobList())
          : _buildProfilePrompt(),
    );
  }
}
