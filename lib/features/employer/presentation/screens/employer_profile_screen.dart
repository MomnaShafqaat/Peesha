import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peesha/features/auth/presentation/screens/login_page.dart';
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

  bool _isProfileSubmitted = false;
  Employer? _submittedEmployer;

  @override
  void initState() {
    super.initState();
    _loadEmployerProfile();
  }

  void _loadEmployerProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('employerProfiles')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final employer = Employer.fromJson(data);
        setState(() {
          _submittedEmployer = employer;
          _isProfileSubmitted = true;

          // Populate form fields with existing data
          _companyName = employer.companyName;
          _industry = employer.industry;
          _location = employer.location;
          _contactEmail = employer.contactEmail;
          _contactPhone = employer.contactPhone;
          _website = employer.website;
          _about = employer.about;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
              appBar:
        AppBar(
            title: const Text('Company Profile'),
            actions: [
            IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
            final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
            TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
            ),
            TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
            ),
            ],
            ),
            );

    if (shouldLogout == true) {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
    );
    }
    }
    },
    ),
    ],
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
              initialValue: _companyName,
              validator: _requiredValidator,
              onSaved: (val) => _companyName = val ?? '',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Industry*',
              initialValue: _industry,
              validator: _requiredValidator,
              onSaved: (val) => _industry = val ?? '',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Location*',
              initialValue: _location,
              validator: _requiredValidator,
              onSaved: (val) => _location = val ?? '',
            ),
            const SizedBox(height: 20),

            const Text('Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            _buildTextField(
              label: 'Contact Email*',
              initialValue: _contactEmail,
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
              initialValue: _contactPhone,
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
              initialValue: _website,
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
              initialValue: _about,
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
  Widget _buildProfileView(Employer employer) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[100],
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(Icons.business, size: 50, color: Colors.blue)
                  : null,
            ),
            const SizedBox(height: 20),

            Text(
              employer.companyName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              employer.industry,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _profileItem("📍 Location", employer.location),
                    _profileItem("📧 Email", employer.contactEmail),
                    _profileItem("📞 Phone", employer.contactPhone),
                    _profileItem("🌐 Website", employer.website),
                    const SizedBox(height: 12),
                    const Text("📝 About Company",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      employer.about,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isProfileSubmitted = false;
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "Not Provided",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    String? prefixText,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    String? initialValue,
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
      initialValue: initialValue,
    );
  }

  String? _requiredValidator(String? value) {
    return value == null || value.isEmpty ? 'Required' : null;
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

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

      await FirebaseFirestore.instance
          .collection('employerProfiles')
          .doc(user.uid)
          .set(employer.toJson());

      setState(() {
        _submittedEmployer = employer;
        _isProfileSubmitted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    }
  }

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
