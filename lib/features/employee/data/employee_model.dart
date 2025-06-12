import 'package:peesha/features/employee/data/education.dart';
import 'package:peesha/features/employee/data/experience.dart';
import 'package:peesha/features/employee/data/certificate.dart';

class Employee {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String city;
  final String country;
  final String profession;
  final String bio;
  final List<Education> educationList;
  final List<Experience> experienceList;
  final List<Certificate> certificateList;

  Employee({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.city,
    required this.country,
    required this.profession,
    required this.bio,
    required this.educationList,
    required this.experienceList,
    required this.certificateList,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? json['name'] ?? 'Unnamed',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    profileImageUrl: json['profileImageUrl'] ?? '',
    city: json['city'] ?? '',
    country: json['country'] ?? '',
    profession: json['profession'] ?? '',
    bio: json['bio'] ?? '',
    educationList: (json['educationList'] as List?)?.map((e) => Education.fromJson(e)).toList() ?? [],
    experienceList: (json['experienceList'] as List?)?.map((e) => Experience.fromJson(e)).toList() ?? [],
    certificateList: (json['certificateList'] as List?)?.map((e) => Certificate.fromJson(e)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'profileImageUrl': profileImageUrl,
    'city': city,
    'country': country,
    'profession': profession,
    'bio': bio,
    'educationList': educationList.map((e) => e.toJson()).toList(),
    'experienceList': experienceList.map((e) => e.toJson()).toList(),
    'certificateList': certificateList.map((e) => e.toJson()).toList(),
  };

  factory Employee.empty() => Employee(
    id: '',
    fullName: '',
    email: '',
    phone: '',
    profileImageUrl: '',
    city: '',
    country: '',
    profession: '',
    bio: '',
    educationList: [],
    experienceList: [],
    certificateList: [],
  );

  Employee copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? city,
    String? country,
    String? profession,
    String? bio,
    List<Education>? educationList,
    List<Experience>? experienceList,
    List<Certificate>? certificateList,
  }) {
    return Employee(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      city: city ?? this.city,
      country: country ?? this.country,
      profession: profession ?? this.profession,
      bio: bio ?? this.bio,
      educationList: educationList ?? this.educationList,
      experienceList: experienceList ?? this.experienceList,
      certificateList: certificateList ?? this.certificateList,
    );
  }
}
