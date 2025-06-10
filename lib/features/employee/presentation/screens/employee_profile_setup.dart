import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/profile_form.dart';
import '../widgets/profile_display_card.dart';

import 'package:peesha/features/employee/presentation/widgets/profile_form.dart';
import 'package:peesha/features/employee/presentation/widgets/profile_display_card.dart';
//import '../../widgets/profile_form.dart';
//import '../../widgets/profile_display_card.dart';


class EmployeeProfileSetup extends StatelessWidget {
  const EmployeeProfileSetup({super.key});

  void saveProfile(Map<String, dynamic> data, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      data['id'] = user.uid;

      await FirebaseFirestore.instance
          .collection('employeeProfiles')
          .doc(user.uid)
          .set(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );

      Navigator.of(context).pop(); // Return to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Profile')),
      body: ProfileForm(
        onSubmit: (data) => saveProfile(data, context),
      ),
    );
  }
}
