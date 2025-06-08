/*lib/features/auth/presentation/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'login_page.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Login Role")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoleButton(role: "Admin", roleKey: "admin"),
            const SizedBox(height: 16),
            RoleButton(role: "Employer", roleKey: "employer"),
            const SizedBox(height: 16),
            RoleButton(role: "Employee", roleKey: "employee"),
          ],
        ),
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final String role;
  final String roleKey;

  const RoleButton({required this.role, required this.roleKey, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(selectedRole: roleKey),
          ),
        );
      },
      child: Text("Login as $role"),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'login_page.dart'; // Make sure this points to the correct login screen with `selectedRole` parameter

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Login Role")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            RoleButton(role: "Admin", roleKey: "admin"),
            SizedBox(height: 16),
            RoleButton(role: "Employer", roleKey: "employer"),
            SizedBox(height: 16),
            RoleButton(role: "Employee", roleKey: "employee"),
          ],
        ),
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final String role;
  final String roleKey;

  const RoleButton({super.key, required this.role, required this.roleKey});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        if (roleKey == 'employer') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginScreen(selectedRole: roleKey),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Only employer login is currently supported'),
            ),
          );
        }
      },
      child: Text("Login as $role"),
    );
  }
}
