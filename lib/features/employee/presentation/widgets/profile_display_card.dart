import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employee/presentation/screens/profile_display.dart';

void saveProfile(Map<String, dynamic> data, BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Add ID and timestamp
    data['id'] = user.uid;
    data['lastUpdated'] = FieldValue.serverTimestamp();

    try {
      // Save profile to Firestore with merge
      await FirebaseFirestore.instance
          .collection('employeeProfiles')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );

      // Navigate to ProfileDisplay with updated data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('employeeProfiles')
                .doc(user.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final profileData = snapshot.data?.data() as Map<String, dynamic>?;

              final employee = profileData != null
                  ? Employee.fromJson(profileData)
                  : Employee.empty();

              return ProfileDisplay(employee: employee);
            },
          ),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    }
  }
}
