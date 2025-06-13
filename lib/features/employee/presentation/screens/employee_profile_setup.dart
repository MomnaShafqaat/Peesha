import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peesha/features/employee/presentation/widgets/form_section_header.dart';
import 'package:peesha/features/employee/presentation/widgets/profile_display_card.dart';
import 'package:peesha/features/employee/data/education.dart';
import 'package:peesha/features/employee/data/experience.dart';
import 'package:peesha/features/employee/data/certificate.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employee/presentation/widgets/profile_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peesha/services/auth_service.dart';
import 'package:peesha/features/auth/presentation/screens/login_page.dart';
class EmployeeProfileSetup extends StatelessWidget {
  const EmployeeProfileSetup({super.key});
  void saveProfile(Map<String, dynamic> data, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      data['id'] = user.uid;
      data['lastUpdated'] = FieldValue.serverTimestamp(); // ✅ optional

      await FirebaseFirestore.instance
          .collection('employeeProfiles')
          .doc(user.uid)
          .set(data, SetOptions(merge: true)); // ✅ use merge

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );

      Navigator.of(context).pop(); // ✅ return to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('employeeProfiles')
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;

          final employee = data != null
              ? Employee.fromJson(data)
              : Employee.empty();

          return ProfileForm(
            employee: employee,
            onSubmit: (data) => saveProfile(data, context),
          );
        },
      ),
    );
  }

}
