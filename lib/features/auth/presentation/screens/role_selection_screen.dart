import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:peesha/features/auth/models/user_role.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Role")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Choose your role", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DropdownButton<UserRole>(
              hint: const Text("Select role"),
              value: selectedRole,
              onChanged: (UserRole? value) {
                setState(() {
                  selectedRole = value;
                });
              },
              items: UserRole.values.map((UserRole role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Text(roleToString(role).toUpperCase()),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: selectedRole != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SignupScreen(role: selectedRole!),
                  ),
                );
              }
                  : null,
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
