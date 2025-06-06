import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peesha/features/auth/presentation/screens/login_page.dart';// Adjust path if needed
import 'package:peesha/features/employer/data/employer_model.dart';
class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

  // Form fields
  String _companyName = '';
  String _industry = '';
  String _location = '';
  String _contactEmail = '';
  String _contactPhone = '';
  String _website = '';
  String _about = '';

  // State to track if profile is submitted
  bool _isProfileSubmitted = false;
  Employer? _submittedEmployer;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
      ),
      body: user == null
          ? Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text('Login to edit your profile'),
        ),
      )
          : _isProfileSubmitted && _submittedEmployer != null
          ? _buildProfileView(_submittedEmployer!)
          : _buildProfileForm(),
    );
  }

  /// Build profile form
  Widget _buildProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[100],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.blue)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            const Text('Company Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            _buildTextField(
              label: 'Company Name*',
              validator: _requiredValidator,
              onSaved: (val) => _companyName = val ?? '',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Industry*',
              validator: _requiredValidator,
              onSaved: (val) => _industry = val ?? '',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Location*',
              validator: _requiredValidator,
              onSaved: (val) => _location = val ?? '',
            ),
            const SizedBox(height: 20),

            const Text('Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            _buildTextField(
              label: 'Contact Email*',
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (!val.contains('@')) return 'Invalid email';
                return null;
              },
              onSaved: (val) => _contactEmail = val ?? '',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Contact Phone*',
              keyboardType: TextInputType.phone,
              validator: _requiredValidator,
              onSaved: (val) => _contactPhone = val ?? '',
            ),
            const SizedBox(height: 20),

            const Text('Additional Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            _buildTextField(
              label: 'Website',
              keyboardType: TextInputType.url,
              prefixText: 'https://',
              onSaved: (val) => _website = val ?? '',
            ),
            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'About Company',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              onSaved: (val) => _about = val ?? '',
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build profile display
  Widget _buildProfileView(Employer employer) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[100],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.business, size: 40, color: Colors.blue)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text("Company Name: ${employer.companyName}"),
            Text("Industry: ${employer.industry}"),
            Text("Location: ${employer.location}"),
            Text("Email: ${employer.contactEmail}"),
            Text("Phone: ${employer.contactPhone}"),
            Text("Website: ${employer.website}"),
            Text("About: ${employer.about}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isProfileSubmitted = false;
                });
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom text field builder
  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    String? prefixText,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefixText,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  /// Required field validator
  String? _requiredValidator(String? value) {
    return value == null || value.isEmpty ? 'Required' : null;
  }

  /// Save profile handler
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final employer = Employer(
        companyName: _companyName,
        industry: _industry,
        companySize: '',
        location: _location,
        address: '',
        city: '',
        state: '',
        country: '',
        postalCode: '',
        contactEmail: _contactEmail,
        contactPhone: _contactPhone,
        contactPersonName: '',
        about: _about,
        website: _website,
        foundedDate: DateTime.now(),
        companyType: '',
      );

      setState(() {
        _submittedEmployer = employer;
        _isProfileSubmitted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );

      // TODO: Save employer to Firebase or backend
    }
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
