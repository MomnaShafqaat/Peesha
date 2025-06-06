class Employee {
  String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profilePictureUrl;
  final String coverPhotoUrl;
  final String headline;
  final String summary;
  final String currentPosition;
  final String currentCompany;
  final String location;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final DateTime dateOfBirth;
  final String gender;
  final List<String> skills;
  final List<Education> education;
  final List<Experience> workExperience;
  final List<Certificate> certifications;
  final List<String> languages;
  final List<String> preferredJobTypes;
  final List<String> preferredLocations;
  final num minSalaryExpectation;
  final String availability;
  final String workAuthorization;
  final List<String> socialMediaLinks;
  final bool isProfileComplete;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Employee({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profilePictureUrl = '',
    this.coverPhotoUrl = '',
    this.headline = '',
    this.summary = '',
    this.currentPosition = '',
    this.currentCompany = '',
    required this.location,
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.postalCode = '',
    required this.dateOfBirth,
    this.gender = 'Prefer not to say',
    this.skills = const [],
    this.education = const [],
    this.workExperience = const [],
    this.certifications = const [],
    this.languages = const [],
    this.preferredJobTypes = const [],
    this.preferredLocations = const [],
    this.minSalaryExpectation = 0,
    this.availability = 'Immediately',
    this.workAuthorization = 'Authorized to work',
    this.socialMediaLinks = const [],
    this.isProfileComplete = false,
    this.isVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'profilePictureUrl': profilePictureUrl,
    'coverPhotoUrl': coverPhotoUrl,
    'headline': headline,
    'summary': summary,
    'currentPosition': currentPosition,
    'currentCompany': currentCompany,
    'location': location,
    'address': address,
    'city': city,
    'state': state,
    'country': country,
    'postalCode': postalCode,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'gender': gender,
    'skills': skills,
    'education': education.map((e) => e.toJson()).toList(),
    'workExperience': workExperience.map((e) => e.toJson()).toList(),
    'certifications': certifications.map((c) => c.toJson()).toList(),
    'languages': languages,
    'preferredJobTypes': preferredJobTypes,
    'preferredLocations': preferredLocations,
    'minSalaryExpectation': minSalaryExpectation,
    'availability': availability,
    'workAuthorization': workAuthorization,
    'socialMediaLinks': socialMediaLinks,
    'isProfileComplete': isProfileComplete,
    'isVerified': isVerified,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      coverPhotoUrl: json['coverPhotoUrl'] ?? '',
      headline: json['headline'] ?? '',
      summary: json['summary'] ?? '',
      currentPosition: json['currentPosition'] ?? '',
      currentCompany: json['currentCompany'] ?? '',
      location: json['location'],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'] ?? 'Prefer not to say',
      skills: List<String>.from(json['skills'] ?? []),
      education: List<Education>.from(
          (json['education'] ?? []).map((e) => Education.fromJson(e))),
      workExperience: List<Experience>.from(
          (json['workExperience'] ?? []).map((e) => Experience.fromJson(e))),
      certifications: List<Certificate>.from(
          (json['certifications'] ?? []).map((c) => Certificate.fromJson(c))),
      languages: List<String>.from(json['languages'] ?? []),
      preferredJobTypes: List<String>.from(json['preferredJobTypes'] ?? []),
      preferredLocations: List<String>.from(json['preferredLocations'] ?? []),
      minSalaryExpectation: json['minSalaryExpectation'] ?? 0,
      availability: json['availability'] ?? 'Immediately',
      workAuthorization: json['workAuthorization'] ?? 'Authorized to work',
      socialMediaLinks: List<String>.from(json['socialMediaLinks'] ?? []),
      isProfileComplete: json['isProfileComplete'] ?? false,
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Employee copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profilePictureUrl,
    String? coverPhotoUrl,
    String? headline,
    String? summary,
    String? currentPosition,
    String? currentCompany,
    String? location,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    DateTime? dateOfBirth,
    String? gender,
    List<String>? skills,
    List<Education>? education,
    List<Experience>? workExperience,
    List<Certificate>? certifications,
    List<String>? languages,
    List<String>? preferredJobTypes,
    List<String>? preferredLocations,
    num? minSalaryExpectation,
    String? availability,
    String? workAuthorization,
    List<String>? socialMediaLinks,
    bool? isProfileComplete,
    bool? isVerified,
  }) {
    return Employee(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      headline: headline ?? this.headline,
      summary: summary ?? this.summary,
      currentPosition: currentPosition ?? this.currentPosition,
      currentCompany: currentCompany ?? this.currentCompany,
      location: location ?? this.location,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      workExperience: workExperience ?? this.workExperience,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      preferredJobTypes: preferredJobTypes ?? this.preferredJobTypes,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      minSalaryExpectation: minSalaryExpectation ?? this.minSalaryExpectation,
      availability: availability ?? this.availability,
      workAuthorization: workAuthorization ?? this.workAuthorization,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String description;

  Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
    'institution': institution,
    'degree': degree,
    'fieldOfStudy': fieldOfStudy,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'isCurrent': isCurrent,
    'description': description,
  };

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      institution: json['institution'],
      degree: json['degree'],
      fieldOfStudy: json['fieldOfStudy'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      description: json['description'] ?? '',
    );
  }
}

class Experience {
  final String title;
  final String company;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String description;

  Experience({
    required this.title,
    required this.company,
    required this.location,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'location': location,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'isCurrent': isCurrent,
    'description': description,
  };

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      title: json['title'],
      company: json['company'],
      location: json['location'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      description: json['description'] ?? '',
    );
  }
}

class Certificate {
  final String name;
  final String issuingOrganization;
  final DateTime issueDate;
  final DateTime? expirationDate;
  final String credentialId;
  final String credentialUrl;

  Certificate({
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    this.expirationDate,
    this.credentialId = '',
    this.credentialUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'issuingOrganization': issuingOrganization,
    'issueDate': issueDate.toIso8601String(),
    'expirationDate': expirationDate?.toIso8601String(),
    'credentialId': credentialId,
    'credentialUrl': credentialUrl,
  };

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      name: json['name'],
      issuingOrganization: json['issuingOrganization'],
      issueDate: DateTime.parse(json['issueDate']),
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      credentialId: json['credentialId'] ?? '',
      credentialUrl: json['credentialUrl'] ?? '',
    );
  }
}