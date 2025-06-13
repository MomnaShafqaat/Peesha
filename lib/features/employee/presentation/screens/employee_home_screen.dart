import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/apply_job_modal.dart';
import 'apply_job_flow_screen.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  final Set<int> _expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Job').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return const Center(child: Text('Error loading jobs'));

          final jobs = snapshot.data?.docs ?? [];

          if (jobs.isEmpty)
            return const Center(child: Text('No jobs available.'));

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index].data() as Map<String, dynamic>;
              final jobId = jobs[index].id;
              final isExpanded = _expandedIndices.contains(index);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(job['title'] ?? 'No Title'),
                      subtitle: Text(job['location'] ?? 'No Location'),
                      trailing: IconButton(
                        icon: AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.expand_more),
                        ),
                        onPressed: () {
                          setState(() {
                            isExpanded
                                ? _expandedIndices.remove(index)
                                : _expandedIndices.add(index);
                          });
                        },
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("📝 Description: ${job['description'] ?? ''}"),
                            const SizedBox(height: 4),
                            Text("📍 Location: ${job['location'] ?? ''}"),
                            Text("💼 Job Type: ${job['jobType'] ?? ''}"),
                            Text("💰 Salary: ${job['salary'] ?? ''}"),
                            Text("📅 Posted: ${job['datePosted'] ?? ''}"),
                            Text("⏳ Deadline: ${job['dateDeadline'] ?? ''}"),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () async {
                                    // TODO: Add save logic here
                                  },
                                  icon: const Icon(Icons.bookmark_border),
                                  label: const Text('Save'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ApplyJobModal(
                                        onUploadResume: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ApplyJobFlowScreen(
                                                jobId: jobId,
                                                jobTitle: job['title'] ?? 'N/A',
                                                companyName: job['company'] ?? 'Unknown',
                                              ),
                                            ),
                                          );
                                        },
                                        onUsePeeshaResume: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ApplyJobFlowScreen(
                                                jobId: jobId,
                                                jobTitle: job['title'] ?? 'N/A',
                                                companyName: job['company'] ?? 'Unknown',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text('Apply'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
