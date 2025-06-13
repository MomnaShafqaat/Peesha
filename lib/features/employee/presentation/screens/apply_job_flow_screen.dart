import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/resume_upload_step.dart';
import '../widgets/experience_input_step.dart';
import '../widgets/employer_questions_step.dart';
import '../widgets/reason_input_step.dart';
import '../widgets/preview_and_submit.dart';
import 'package:peesha/features/employee/data/employee_model.dart'; // adjust this path if needed

class ApplyJobFlowScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;
  final String companyName;

  const ApplyJobFlowScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
  });

  @override
  State<ApplyJobFlowScreen> createState() => _ApplyJobFlowScreenState();
}

class _ApplyJobFlowScreenState extends State<ApplyJobFlowScreen> {
  int _stepIndex = 0;
  String? resumeUrl, selectedResumeName;
  String? experienceTitle, experienceCompany;
  String? availability, relatedExperience;
  String? reason;

  String fullName = '';
  String email = '';
  String phone = '';

  bool isLoadingProfile = true;

  void nextStep() => setState(() => _stepIndex++);
  void prevStep() => setState(() => _stepIndex--);

  void setResume(String url, String name) {
    resumeUrl = url;
    selectedResumeName = name;
  }

  void setExperience(String title, String company) {
    experienceTitle = title;
    experienceCompany = company;
  }

  void setEmployerAnswers(String avail, String exp) {
    availability = avail;
    relatedExperience = exp;
  }

  void setReason(String r) => reason = r;

  void onApplicationSubmitted() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Application submitted successfully!")),
    );
    Navigator.pop(context);
  }

  Future<void> fetchEmployeeProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('employeeProfiles') // adjust collection name if needed
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final employee = Employee.fromJson(doc.data()!);
        setState(() {
          fullName = employee.fullName;
          email = employee.email;
          phone = employee.phone;
          isLoadingProfile = false;
        });
      } else {
        setState(() => isLoadingProfile = false);
        print("Employee profile not found");
      }
    } catch (e) {
      print("Error fetching employee profile: $e");
      setState(() => isLoadingProfile = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEmployeeProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingProfile) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final steps = [
      ResumeUploadStep(onResumeSelected: setResume, onNext: nextStep),
      ExperienceInputStep(
          onExperienceEntered: setExperience, onNext: nextStep, onBack: prevStep),
      EmployerQuestionsStep(
          onQuestionsAnswered: setEmployerAnswers,
          onNext: nextStep,
          onBack: prevStep),
      ReasonInputStep(
          onReasonEntered: setReason, onNext: nextStep, onBack: prevStep),
      PreviewAndSubmitStep(
        resumeUrl: resumeUrl ?? '',
        selectedResumeName: selectedResumeName ?? '',
        experienceTitle: experienceTitle ?? '',
        experienceCompany: experienceCompany ?? '',
        availability: availability ?? '',
        relatedExperience: relatedExperience ?? '',
        reason: reason ?? '',
        fullName: fullName,
        email: email,
        phone: phone,
        onSubmitSuccess: onApplicationSubmitted,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: steps[_stepIndex],
    );
  }
}
