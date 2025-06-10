import 'package:flutter/material.dart';

class ProfileDisplayCard extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const ProfileDisplayCard({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profileData['fullName'] ?? 'Name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('📧 Email: ${profileData['email'] ?? ''}'),
            Text('📱 Phone: ${profileData['phone'] ?? ''}'),
            Text('🌆 City: ${profileData['city'] ?? ''}'),
            Text('🌍 Country: ${profileData['country'] ?? ''}'),
            Text('👩‍💼 Profession: ${profileData['profession'] ?? ''}'),
            const SizedBox(height: 10),
            Text('📝 Bio:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(profileData['bio'] ?? ''),
          ],
        ),
      ),
    );
  }
}
