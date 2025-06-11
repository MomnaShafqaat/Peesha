
import 'package:peesha/features/employee/data/education.dart';
import 'package:peesha/features/employee/data/employee_model.dart';

import 'package:peesha/features/employee/data/certificate.dart';

// lib/features/employee/data/experience.dart
class ReferencePerson {
  final String name;
  final String position;
  final String contactEmail;
  final String? phone;

  ReferencePerson({
    required this.name,
    required this.position,
    required this.contactEmail,
    this.phone,
  });

  factory ReferencePerson.fromJson(Map<String, dynamic> json) => ReferencePerson(
    name: json['name'],
    position: json['position'],
    contactEmail: json['contactEmail'],
    phone: json['phone'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'position': position,
    'contactEmail': contactEmail,
    'phone': phone,
  };
}

class Experience {
  final String jobTitle;
  final String company;
  final String location;
  final String? companyWebsite;
  final String employmentType;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final String description;
  final bool isRemote;
  final bool isHybrid;
  final ReferencePerson? reference;

  Experience({
    required this.jobTitle,
    required this.company,
    required this.location,
    this.companyWebsite,
    required this.employmentType,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.description,
    this.isRemote = false,
    this.isHybrid = false,
    this.reference,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    jobTitle: json['jobTitle'],
    company: json['company'],
    location: json['location'],
    companyWebsite: json['companyWebsite'],
    employmentType: json['employmentType'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    isCurrent: json['isCurrent'] ?? false,
    description: json['description'],
    isRemote: json['isRemote'] ?? false,
    isHybrid: json['isHybrid'] ?? false,
    reference: json['reference'] != null
        ? ReferencePerson.fromJson(json['reference'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'jobTitle': jobTitle,
    'company': company,
    'location': location,
    'companyWebsite': companyWebsite,
    'employmentType': employmentType,
    'startDate': startDate,
    'endDate': endDate,
    'isCurrent': isCurrent,
    'description': description,
    'isRemote': isRemote,
    'isHybrid': isHybrid,
    'reference': reference?.toJson(),
  };

  factory Experience.empty() => Experience(
    jobTitle: '',
    company: '',
    location: '',
    companyWebsite: '',
    employmentType: '',
    startDate: '',
    endDate: '',
    isCurrent: false,
    description: '',
    isRemote: false, // ✅ was: ''
    isHybrid: false, // ✅ was: ''
    reference: null, // ✅ was: ''
  );

}
