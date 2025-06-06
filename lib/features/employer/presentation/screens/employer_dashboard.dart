import 'package:flutter/material.dart';
import 'package:peesha/features/employer/presentation/screens/employer_profile_setup.dart';
import 'package:peesha/features/employer/presentation/screens/job_post_screen.dart';
import 'package:peesha/features/employer/presentation/widgets/dashboard_card.dart';

class EmployerDashboard extends StatelessWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployerProfileSetup(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardCard(
              icon: Icons.business,
              title: 'Company Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmployerProfileSetup(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            DashboardCard(
              icon: Icons.post_add,
              title: 'Post a Job',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JobPostScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            DashboardCard(
              icon: Icons.people,
              title: 'View Applicants',
              onTap: () {
                // Navigate to applicants screen
              },
            ),
          ],
        ),
      ),
    );
  }
}