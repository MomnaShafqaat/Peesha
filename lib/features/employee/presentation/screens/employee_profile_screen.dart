
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employee/presentation/widgets/form_section_header.dart';
import 'package:peesha/features/employee/presentation/widgets/profile_display_card.dart';
import 'package:peesha/features/employee/presentation/widgets/profile_form.dart'; // ✅ correct
import 'package:peesha/features/employee/presentation/screens/profile_display.dart'; // ✅ correct

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Employee? _employee;
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeProfile();
  }

  Future<void> _fetchEmployeeProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('employeeProfiles').doc(user.uid).get();

    setState(() {
      if (doc.exists) {
        _employee = Employee.fromJson(doc.data()!);
        _isEditing = false;
      } else {
        _employee = Employee(
          id: user.uid,
          fullName: '',
          email: user.email ?? '',
          phone: '',
          profileImageUrl: '',
          city: '',
          country: '',
          profession: '',
          bio: '',
          educationList: [],
          experienceList: [],
          certificateList: [],
        );
        _isEditing = true;
      }
      _isLoading = false;
    });
  }

  Future<void> _saveProfile(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('employeeProfiles').doc(user.uid).set(data);
    await _fetchEmployeeProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing && _employee != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isEditing
          ? ProfileForm(
        employee: _employee!,
        onSubmit: (data) async {
          await _saveProfile(data);
          setState(() => _isEditing = false);
        },
        onCancel: () => setState(() => _isEditing = false),
      )
          : ProfileDisplay(employee: _employee!),
    );
  }
}
