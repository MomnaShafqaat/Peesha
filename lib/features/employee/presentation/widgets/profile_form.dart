import 'package:flutter/material.dart';

class ProfileForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;

  const ProfileForm({super.key, required this.onSubmit});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _professionController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Full Name')),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            TextFormField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
            TextFormField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country')),
            TextFormField(controller: _professionController, decoration: const InputDecoration(labelText: 'Profession')),
            TextFormField(controller: _bioController, decoration: const InputDecoration(labelText: 'Bio')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit({
                    'fullName': _fullNameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'city': _cityController.text,
                    'country': _countryController.text,
                    'profession': _professionController.text,
                    'bio': _bioController.text,
                    'educationList': [],
                    'experienceList': [],
                    'certificateList': [],
                    'profileImageUrl': '',
                    'id': '',
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}