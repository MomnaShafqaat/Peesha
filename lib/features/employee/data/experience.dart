class Experience {
  final String jobTitle;
  final String company;
  final String location; // City, Country
  final String? companyWebsite;
  final String employmentType; // Full-time, Part-time, Contract, Freelance, Internship
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final String description;
  final bool isRemote; // true if job was remote
  final bool isHybrid; // true if job was hybrid
  final ReferencePerson? reference; // Optional reference person

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

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
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
  }

  Map<String, dynamic> toJson() {
    return {
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
  }
}

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

  factory ReferencePerson.fromJson(Map<String, dynamic> json) {
    return ReferencePerson(
      name: json['name'],
      position: json['position'],
      contactEmail: json['contactEmail'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'contactEmail': contactEmail,
      'phone': phone,
    };
  }
}
