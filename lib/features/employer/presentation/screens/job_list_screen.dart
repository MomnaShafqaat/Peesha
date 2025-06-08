import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  // Track which job card is expanded
  final Set<int> _expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posted Jobs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Job').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          final jobs = snapshot.data?.docs ?? [];

          if (jobs.isEmpty) {
            return const Center(child: Text('No jobs posted yet.'));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index].data() as Map<String, dynamic>;

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
                            if (isExpanded) {
                              _expandedIndices.remove(index);
                            } else {
                              _expandedIndices.add(index);
                            }
                          });
                        },
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                                  onPressed: () {
                                    // Handle save logic here
                                  },
                                  icon: const Icon(Icons.bookmark_border),
                                  label: const Text('Save'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle apply logic here
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
