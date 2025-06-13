import 'package:flutter/material.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employee/presentation/widgets/form_section_header.dart';
import 'package:peesha/features/employee/data/education.dart';
import 'package:peesha/features/employee/data/experience.dart';
import 'package:peesha/features/employee/data/certificate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peesha/services/auth_service.dart';
import 'package:peesha/features/auth/presentation/screens/login_page.dart';
class ProfileDisplay extends StatelessWidget {
  final Employee employee;

  const ProfileDisplay({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Profile'),
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
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),

            const FormSectionHeader(title: 'Basic Information'),
            _buildInfoCard([
              _buildInfoItem('Profession', employee.profession),
              _buildInfoItem('Email', employee.email),
              _buildInfoItem('Phone', employee.phone),
              _buildInfoItem('Location', '${employee.city}, ${employee.country}'),
            ]),
            const SizedBox(height: 16),

            if (employee.bio.isNotEmpty) ...[
              const FormSectionHeader(title: 'About Me'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(employee.bio),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (employee.educationList.isNotEmpty) ...[
              const FormSectionHeader(title: 'Education'),
              ...employee.educationList.map(_buildEducationCard).toList(),
            ],

            if (employee.experienceList.isNotEmpty) ...[
              const SizedBox(height: 16),
              const FormSectionHeader(title: 'Experience'),
              ...employee.experienceList.map(_buildExperienceCard).toList(),
            ],

            if (employee.certificateList.isNotEmpty) ...[
              const SizedBox(height: 16),
              const FormSectionHeader(title: 'Certifications'),
              ...employee.certificateList.map(_buildCertificateCard).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: employee.profileImageUrl.isNotEmpty
              ? NetworkImage(employee.profileImageUrl)
              : null,
          child: employee.profileImageUrl.isEmpty
              ? const Icon(Icons.person, size: 40)
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employee.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (employee.profession.isNotEmpty)
              Text(
                employee.profession,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isNotEmpty ? value : 'Not specified')),
        ],
      ),
    );
  }

  Widget _buildEducationCard(Education education) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education.level,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(education.instituteName),
            Text('${education.boardOrUniversity}, ${education.country}'),
            Text(education.fieldOfStudy),
            Text(
              '${education.startDate} - ${education.isOngoing ? 'Present' : education.endDate}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text('Result: ${education.result}'),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(Experience experience) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.jobTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(experience.company),
            Text(experience.location),
            Text(
              '${experience.startDate} - ${experience.isCurrent ? 'Present' : experience.endDate}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(experience.employmentType),
            if (experience.description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(experience.description),
                ],
              ),
            if (experience.reference != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text('Reference:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${experience.reference!.name} (${experience.reference!.position})'),
                  Text('Email: ${experience.reference!.contactEmail}'),
                  if (experience.reference!.phone != null)
                    Text('Phone: ${experience.reference!.phone}'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateCard(Certificate certificate) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              certificate.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(certificate.organization),
            Text('Issued: ${certificate.issueDate}'),
            if (certificate.expiryDate.isNotEmpty)
              Text('Expires: ${certificate.expiryDate}'),
          ],
        ),
      ),
    );
  }
}
