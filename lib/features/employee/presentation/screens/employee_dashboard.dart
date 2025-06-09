import 'package:flutter/material.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Employee'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Recommended Jobs'),
          _buildJobCard(title: 'Flutter Developer', company: 'Techverse Inc.', location: 'Remote'),
          _buildJobCard(title: 'Backend Engineer', company: 'PakDev', location: 'Lahore, Pakistan'),

          const SizedBox(height: 24),

          _buildSectionTitle('Saved Jobs'),
          _buildJobCard(title: 'UI/UX Designer', company: 'DesignHub', location: 'Karachi, Pakistan'),

          const SizedBox(height: 24),

          _buildSectionTitle('My Applications'),
          _buildApplicationStatusCard('React Developer', 'Applied'),
          _buildApplicationStatusCard('Python Engineer', 'Under Review'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          // Add logic here to navigate to other screens
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildJobCard({required String title, required String company, required String location}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.work, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text('$company • $location'),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
        onTap: () {
          // Navigate to job detail
        },
      ),
    );
  }

  Widget _buildApplicationStatusCard(String jobTitle, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(jobTitle),
        subtitle: Text('Status: $status'),
      ),
    );
  }
}
