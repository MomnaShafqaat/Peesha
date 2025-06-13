import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peesha/services/auth_service.dart';
import 'package:peesha/features/employer/data/job_model.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employer/data/employer_model.dart';
import 'package:peesha/services/auth_service.dart';
import 'admin_home_screen.dart';
class JobPostScreen extends StatelessWidget {
  const JobPostScreen({super.key});

  Future<void> deleteJob(String jobId) async {
    try {
      await FirebaseFirestore.instance.collection('Job').doc(jobId).delete();
    } catch (e) {
      debugPrint('Failed to delete job: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posted Jobs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Job').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No jobs found.'));
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${job.location} • ${job.jobType}'),
                      Text('Employer: ${job.employerName}'),
                      Text('Deadline: ${job.dateDeadline}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Job'),
                          content: const Text('Are you sure you want to delete this job?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await deleteJob(job.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}