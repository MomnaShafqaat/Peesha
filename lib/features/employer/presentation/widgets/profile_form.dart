import 'package:flutter/material.dart';
import 'package:peesha/features/employer/data/employer_model.dart';


class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Employer employer;
  final VoidCallback onSave;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.employer,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Organization Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter organization name';
              }
              return null;
            },
            onSaved: (value) => employer.companyName = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Industry'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter industry';
              }
              return null;
            },
            onSaved: (value) => employer.industry = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Location'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter location';
              }
              return null;
            },
            onSaved: (value) => employer.location = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Contact Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) => employer.contactEmail = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Contact Phone'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
            onSaved: (value) => employer.contactPhone = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Website'),
            keyboardType: TextInputType.url,
            onSaved: (value) => employer.website = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'About Company'),
            maxLines: 3,
            onSaved: (value) => employer.about = value!,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSave,
            child: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }
}