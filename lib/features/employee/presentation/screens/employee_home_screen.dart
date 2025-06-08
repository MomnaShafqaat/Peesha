import 'package:flutter/material.dart';
import 'package:peesha/services/auth_service.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/role-selection',
                      (route) => false
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome Employee!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}