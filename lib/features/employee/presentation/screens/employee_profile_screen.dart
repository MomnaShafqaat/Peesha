import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_form.dart';
import '../widgets/profile_display_card.dart';

import 'package:peesha/features/employee/presentation/widgets/profile_form.dart';
import 'package:peesha/features/employee/presentation/widgets/profile_display_card.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('employeeProfiles').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || !snapshot.data!.exists)
            return const Center(child: Text('No profile found.'));

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text("Name: ${data['fullName']}"),
                Text("Email: ${data['email']}"),
                Text("Phone: ${data['phone']}"),
                Text("City: ${data['city']}"),
                Text("Country: ${data['country']}"),
                Text("Profession: ${data['profession']}"),
                Text("Bio: ${data['bio']}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
