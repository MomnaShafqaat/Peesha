import 'package:flutter/material.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employee/presentation/widgets/form_text_field.dart';
import 'package:peesha/features/employee/presentation/widgets/education_form.dart';
import 'package:peesha/features/employee/presentation/widgets/experience_form.dart';
import 'package:peesha/features/employee/presentation/widgets/certificate_form.dart';
import 'package:peesha/features/employee/presentation/widgets/form_section_header.dart';
import 'package:peesha/features/employee/data/education.dart';
import 'package:peesha/features/employee/data/experience.dart';
import 'package:peesha/features/employee/data/certificate.dart';


class ProfileForm extends StatefulWidget {
  final Employee employee;
  final void Function(Map<String, dynamic>) onSubmit;
  final VoidCallback? onCancel;

  const ProfileForm({
    super.key,
    required this.employee,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _professionController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  List<Education> _educationList = [];
  List<Experience> _experienceList = [];
  List<Certificate> _certificateList = [];

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;
    _nameController = TextEditingController(text: emp.fullName);
    _emailController = TextEditingController(text: emp.email);
    _phoneController = TextEditingController(text: emp.phone);
    _professionController = TextEditingController(text: emp.profession);
    _bioController = TextEditingController(text: emp.bio);
    _cityController = TextEditingController(text: emp.city);
    _countryController = TextEditingController(text: emp.country);
    _educationList = [...emp.educationList];
    _experienceList = [...emp.experienceList];
    _certificateList = [...emp.certificateList];
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = widget.employee.copyWith(
        fullName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        profession: _professionController.text,
        bio: _bioController.text,
        city: _cityController.text,
        country: _countryController.text,
        educationList: _educationList,
        experienceList: _experienceList,
        certificateList: _certificateList,
      ).toJson();
      print('Saving data: $data'); // ✅ DEBUG

// Check if profession or phone is empty — are your controllers initialized right?

      widget.onSubmit(data);
    }
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
            FormTextField(controller: _nameController, label: 'Full Name', isRequired: true),
            FormTextField(controller: _emailController, label: 'Email', isEmail: true, isRequired: true),
            FormTextField(controller: _phoneController, label: 'Phone', isPhone: true),
            FormTextField(controller: _professionController, label: 'Profession'),
            FormTextField(controller: _bioController, label: 'Bio', maxLines: 3),
            FormTextField(controller: _cityController, label: 'City'),
            FormTextField(controller: _countryController, label: 'Country'),

            const SizedBox(height: 16),
            FormSectionHeader(title: 'Education', onAdd: () {
              setState(() {
                _educationList.add(Education.empty());
              });
            }),
            ..._educationList.asMap().entries.map((entry) {
              final index = entry.key;
              final edu = entry.value;
              return EducationForm(
                index: index,
                education: edu,
                onChanged: (updated) => setState(() => _educationList[index] = updated),
                onDelete: () => setState(() => _educationList.removeAt(index)),
              );
            }),

            const SizedBox(height: 16),
            FormSectionHeader(title: 'Experience', onAdd: () {
              setState(() {
                _experienceList.add(Experience.empty());
              });
            }),
            ..._experienceList.asMap().entries.map((entry) {
              final index = entry.key;
              final exp = entry.value;
              return ExperienceForm(
                index: index,
                experience: exp,
                onChanged: (updated) => setState(() => _experienceList[index] = updated),
                onDelete: () => setState(() => _experienceList.removeAt(index)),
              );
            }),

            const SizedBox(height: 16),
            FormSectionHeader(title: 'Certificates', onAdd: () {
              setState(() {
                _certificateList.add(Certificate.empty());
              });
            }),
            ..._certificateList.asMap().entries.map((entry) {
              final index = entry.key;
              final cert = entry.value;
              return CertificateForm(
                index: index,
                certificate: cert,
                onUpdate: (updated) => setState(() => _certificateList[index] = updated),
                onDelete: () => setState(() => _certificateList.removeAt(index)),
              );
            }),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.onCancel != null)
                  TextButton(onPressed: widget.onCancel, child: const Text('Cancel')),
                ElevatedButton(onPressed: _submit, child: const Text('Save Profile')),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}
