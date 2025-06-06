import 'package:flutter/material.dart';
import 'package:peesha/features/employer/data/employer_model.dart';
import 'package:peesha/features/employer/data/employer_repository.dart';
import 'package:peesha/features/employer/presentation/widgets/profile_form.dart';

class EmployerProfileSetup extends StatefulWidget {
  const EmployerProfileSetup({super.key});

  @override
  _EmployerProfileSetupState createState() => _EmployerProfileSetupState();
}

class _EmployerProfileSetupState extends State<EmployerProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final _repository = EmployerRepository();

  final _employer = Employer(
    companyName: '',
    industry: '',
    companySize: '',
    location: '',
    address: '',
    city: '',
    state: '',
    country: '',
    postalCode: '',
    contactEmail: '',
    contactPhone: '',
    contactPersonName: '',
    about: '',
    website: '',
    foundedDate: DateTime.now(),
    companyType: '',
  );

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _repository.createEmployer(_employer);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ProfileForm(
          formKey: _formKey,
          employer: _employer,
          onSave: _saveProfile,
        ),
      ),
    );
  }
}
