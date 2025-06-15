import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JobApplicationsScreen extends StatelessWidget {
  const JobApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Text(
          'Job Applications',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .orderBy('appliedAt', descending: true)
            .snapshots(),
        builder: (context, appSnap) {
          if (appSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final applications = appSnap.data?.docs ?? [];

          if (applications.isEmpty) {
            return const Center(
              child: Text('No applications found.', style: TextStyle(color: Colors.black)),
            );
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final doc = applications[index];
              final data = doc.data() as Map<String, dynamic>;

              final appliedAt = (data['appliedAt'] as Timestamp?)?.toDate();
              final formattedDate = appliedAt != null
                  ? DateFormat.yMMMd().add_jm().format(appliedAt)
                  : 'Unknown';

              return Card(
                margin: const EdgeInsets.all(12),
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Applicant: ${data['fullName'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Email: ${data['email'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.black)),
                      Text('Phone: ${data['phone'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.black)),
                      Text('Applied At: $formattedDate',
                          style: const TextStyle(color: Colors.black)),
                      const Divider(height: 20),
                      Text(
                        'Experience: ${data['experienceTitle'] ?? 'N/A'} at ${data['experienceCompany'] ?? 'N/A'}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text('Availability: ${data['availability'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.black)),
                      Text('Reason: ${data['reason'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.black)),
                      Text('Related Experience: ${data['relatedExperience'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                          onPressed: data['resumeUrl'] != null
                              ? () {
                            final url = data['resumeUrl'];
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Resume URL: $url')),
                            );
                            // TODO: Use url_launcher to open link
                          }
                              : null,
                          child: const Text('View Resume'),
                        ),
                      ),
                    ],
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
