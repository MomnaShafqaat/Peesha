/*import 'package:flutter/material.dart';
import 'package:peesha/features/employer/presentation/screens/employer_profile_setup.dart';
import 'package:peesha/features/employer/presentation/screens/job_post_screen.dart';
import 'package:peesha/features/employer/presentation/widgets/dashboard_card.dart';
import 'package:peesha/features/employer/presentation//widgets/banner_ad_widget.dart'; // ✅ Import the ad widget

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
      body: Column(
        children: [
          Expanded(
            child: Padding(
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
          ),
          const BannerAdWidget(), // ✅ Add the banner ad at the bottom
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:peesha/features/employer/presentation/screens/employer_profile_setup.dart';
import 'package:peesha/features/employer/presentation/screens/job_post_screen.dart';
import 'package:peesha/features/employer/presentation/screens/job_application_screen.dart'; // 👈 New import
import 'package:peesha/features/employer/presentation/widgets/dashboard_card.dart';
import 'package:peesha/features/employer/presentation/widgets/banner_ad_widget.dart';

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
      body: Column(
        children: [
          Expanded(
            child: Padding(
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
                    title: 'Job Applications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JobApplicationsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}