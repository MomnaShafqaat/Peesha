// features/employee/presentation/screens/profile_form.dart

import 'package:flutter/material.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employee/data/education.dart';
import 'package:peesha/features/employee/data/experience.dart';
import 'package:peesha/features/employee/data/certificate.dart';
import 'package:peesha/features/employee/presentation/widgets/education_form.dart';
import 'package:peesha/features/employee/presentation/widgets/experience_form.dart';
import 'package:peesha/features/employee/presentation/widgets/certificate_form.dart';
import 'package:peesha/features/employee/presentation/widgets/form_section_header.dart';
import 'package:peesha/features/employee/presentation/widgets/form_text_field.dart';



class ProfileForm extends StatefulWidget {
  final Employee employee;
  final void Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onCancel;

  const ProfileForm({super.key, required this.employee, required this.onSubmit, required this.onCancel});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _professionController;
  late TextEditingController _bioController;

  late List<Education> _educationList;
  late List<Experience> _experienceList;
  late List<Certificate> _certificateList;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.employee.fullName);
    _emailController = TextEditingController(text: widget.employee.email);
    _phoneController = TextEditingController(text: widget.employee.phone);
    _cityController = TextEditingController(text: widget.employee.city);
    _countryController = TextEditingController(text: widget.employee.country);
    _professionController = TextEditingController(text: widget.employee.profession);
    _bioController = TextEditingController(text: widget.employee.bio);

    _educationList = List.from(widget.employee.educationList);
    _experienceList = List.from(widget.employee.experienceList);
    _certificateList = List.from(widget.employee.certificateList);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            FormSectionHeader(title: 'Basic Information'),
            FormTextField(controller: _fullNameController, label: 'Full Name', isRequired: true),
            FormTextField(controller: _emailController, label: 'Email', isRequired: true, isEmail: true),
            FormTextField(controller: _phoneController, label: 'Phone', isPhone: true),
            FormTextField(controller: _professionController, label: 'Profession'),
            Row(
              children: [
                Expanded(child: FormTextField(controller: _cityController, label: 'City')),
                const SizedBox(width: 16),
                Expanded(child: FormTextField(controller: _countryController, label: 'Country')),
              ],
            ),
            FormTextField(controller: _bioController, label: 'About Me', maxLines: 3),
            const SizedBox(height: 24),

            FormSectionHeader(
              title: 'Education',
              onAdd: () => setState(() => _educationList.add(Education.empty())),
            ),
            ..._educationList.asMap().entries.map((entry) => EducationForm(
              key: ValueKey(entry.key),
              index: entry.key,
              education: entry.value,
              onChanged: (e) => setState(() => _educationList[entry.key] = e),
              onDelete: () => setState(() => _educationList.removeAt(entry.key)),
            )),


            const SizedBox(height: 16),

            FormSectionHeader(
              title: 'Experience',
              onAdd: () => setState(() => _experienceList.add(Experience.empty())),
            ),
            ..._experienceList.asMap().entries.map((entry) => ExperienceForm(
              key: ValueKey(entry.key),
              index: entry.key,
              experience: entry.value,
              onChanged: (e) => setState(() => _experienceList[entry.key] = e),
              onDelete: () => setState(() => _experienceList.removeAt(entry.key)),
            )),

            const SizedBox(height: 16),

            FormSectionHeader(
              title: 'Certifications',
              onAdd: () => setState(() => _certificateList.add(Certificate.empty())),
            ),
            ..._certificateList.asMap().entries.map((entry) => CertificateForm(
              key: ValueKey(entry.key),
              index: entry.key,
              certificate: entry.value,
              onUpdate: (c) => setState(() => _certificateList[entry.key] = c),
              onDelete: () => setState(() => _certificateList.removeAt(entry.key)),
            )),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: widget.onCancel, child: const Text('Cancel')),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: _submitForm, child: const Text('Save Profile')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'id': widget.employee.id,
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'city': _cityController.text,
        'country': _countryController.text,
        'profession': _professionController.text,
        'bio': _bioController.text,
        'profileImageUrl': widget.employee.profileImageUrl,
        'educationList': _educationList.map((e) => e.toJson()).toList(),
        'experienceList': _experienceList.map((e) => e.toJson()).toList(),
        'certificateList': _certificateList.map((c) => c.toJson()).toList(),
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _professionController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
