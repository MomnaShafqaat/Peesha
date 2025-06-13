import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PreviewAndSubmitStep extends StatefulWidget {
  final String resumeUrl;
  final String selectedResumeName;
  final String experienceTitle;
  final String experienceCompany;
  final String availability;
  final String relatedExperience;
  final String reason;
  final String fullName;
  final String email;
  final String phone;
  final VoidCallback onSubmitSuccess;

  const PreviewAndSubmitStep({
    super.key,
    required this.resumeUrl,
    required this.selectedResumeName,
    required this.experienceTitle,
    required this.experienceCompany,
    required this.availability,
    required this.relatedExperience,
    required this.reason,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.onSubmitSuccess,
  });

  @override
  State<PreviewAndSubmitStep> createState() => _PreviewAndSubmitStepState();
}

class _PreviewAndSubmitStepState extends State<PreviewAndSubmitStep> {
  late String _resumeUrl, _resumeName;
  late String _experienceTitle, _experienceCompany;
  late String _availability, _relatedExperience, _reason;
  late String _fullName, _email, _phone;

  bool _editResume = false, _editExp = false, _editEmployer = false, _editReason = false;
  bool _editFullName = false, _editEmail = false, _editPhone = false;

  final _expTitleCtl = TextEditingController();
  final _expCompanyCtl = TextEditingController();
  final _availCtl = TextEditingController();
  final _relatedExpCtl = TextEditingController();
  final _reasonCtl = TextEditingController();
  final _fullNameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resumeUrl = widget.resumeUrl;
    _resumeName = widget.selectedResumeName;

    _experienceTitle = widget.experienceTitle;
    _experienceCompany = widget.experienceCompany;
    _expTitleCtl.text = _experienceTitle;
    _expCompanyCtl.text = _experienceCompany;

    _availability = widget.availability;
    _relatedExperience = widget.relatedExperience;
    _availCtl.text = _availability;
    _relatedExpCtl.text = _relatedExperience;

    _reason = widget.reason;
    _reasonCtl.text = _reason;

    _fullName = widget.fullName;
    _email = widget.email;
    _phone = widget.phone;
    _fullNameCtl.text = _fullName;
    _emailCtl.text = _email;
    _phoneCtl.text = _phone;
  }

  @override
  void dispose() {
    _expTitleCtl.dispose();
    _expCompanyCtl.dispose();
    _availCtl.dispose();
    _relatedExpCtl.dispose();
    _reasonCtl.dispose();
    _fullNameCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  Future<void> _pickNewResume() async {
    final result = await FilePicker.platform.pickFiles(
        withReadStream: true, type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
    if (result != null && result.files.isNotEmpty) {
      final f = result.files.first;
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dzqvnnsyj/auto/upload');
      final req = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'resume_upload'
        ..files.add(http.MultipartFile('file', f.readStream!, f.size, filename: f.name));
      final res = await req.send();
      if (res.statusCode == 200) {
        final str = await res.stream.bytesToString();
        final data = json.decode(str);
        setState(() {
          _resumeUrl = data['secure_url'];
          _resumeName = f.name;
          _editResume = false;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Upload failed: ${res.statusCode}")));
      }
    }
  }

  Future<void> _confirmSubmit() async {
    if ([
      _fullName, _email, _phone,
      _experienceTitle, _experienceCompany,
      _availability, _relatedExperience, _reason
    ].any((e) => e.trim().isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('All fields must be filled before submitting')));
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Submit Application?"),
        content: const Text("Confirm submission."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Submit")),
        ],
      ),
    );
    if (ok == true) _submitToFirestore();
  }

  Future<void> _submitToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('applications').add({
        'userId': user.uid,
        'resumeUrl': _resumeUrl,
        'resumeName': _resumeName,
        'fullName': _fullName,
        'email': _email,
        'phone': _phone,
        'experienceTitle': _experienceTitle,
        'experienceCompany': _experienceCompany,
        'availability': _availability,
        'relatedExperience': _relatedExperience,
        'reason': _reason,
        'appliedAt': Timestamp.now(),
      });
      widget.onSubmitSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submit failed: $e")));
    }
  }

  Widget _labeledField({
    required String label,
    required Widget child,
    required VoidCallback onEdit,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review & Submit")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text("Profile & Application Summary", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),

          _labeledField(
            label: "Full Name",
            child: _editFullName
                ? TextField(controller: _fullNameCtl, onChanged: (v) => _fullName = v.trim())
                : Text(_fullName),
            onEdit: () => setState(() => _editFullName = !_editFullName),
          ),

          _labeledField(
            label: "Email",
            child: _editEmail
                ? TextField(controller: _emailCtl, onChanged: (v) => _email = v.trim())
                : Text(_email),
            onEdit: () => setState(() => _editEmail = !_editEmail),
          ),

          _labeledField(
            label: "Phone",
            child: _editPhone
                ? TextField(controller: _phoneCtl, onChanged: (v) => _phone = v.trim())
                : Text(_phone),
            onEdit: () => setState(() => _editPhone = !_editPhone),
          ),

          _labeledField(
            label: "Resume",
            child: GestureDetector(
              onTap: _editResume ? _pickNewResume : null,
              child: Text(_resumeName, style: TextStyle(color: _editResume ? Colors.blue : Colors.black)),
            ),
            onEdit: () => setState(() => _editResume = !_editResume),
          ),

          _labeledField(
            label: "Job and Company",
            child: _editExp
                ? Column(children: [
              TextField(controller: _expTitleCtl, decoration: const InputDecoration(labelText: 'Job Title'), onChanged: (v) => _experienceTitle = v.trim()),
              TextField(controller: _expCompanyCtl, decoration: const InputDecoration(labelText: 'Company'), onChanged: (v) => _experienceCompany = v.trim()),
            ])
                : Text("$_experienceTitle at $_experienceCompany"),
            onEdit: () => setState(() => _editExp = !_editExp),
          ),

          _labeledField(
            label: "Interview Date and Time",
            child: _editEmployer
                ? TextField(controller: _availCtl, onChanged: (v) => _availability = v.trim())
                : Text(_availability),
            onEdit: () => setState(() => _editEmployer = !_editEmployer),
          ),

          _labeledField(
            label: "Related Experience",
            child: _editEmployer
                ? TextField(controller: _relatedExpCtl, onChanged: (v) => _relatedExperience = v.trim())
                : Text(_relatedExperience),
            onEdit: () => setState(() => _editEmployer = !_editEmployer),
          ),

          _labeledField(
            label: "Reason for Applying",
            child: _editReason
                ? TextField(controller: _reasonCtl, maxLines: 4, onChanged: (v) => _reason = v.trim())
                : Text(_reason),
            onEdit: () => setState(() => _editReason = !_editReason),
          ),

          const SizedBox(height: 24),
          Center(child: ElevatedButton(onPressed: _confirmSubmit, child: const Text("Submit Application"))),
        ],
      ),
    );
  }
}
