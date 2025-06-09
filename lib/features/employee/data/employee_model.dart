class Employee {
  String id;
  String fullName;
  String email;
  String phone;
  String profileImageUrl; // Stored in Firebase Storage
  String city;
  String country;
  String profession;
  String bio;
  List<Education> educationList;
  List<Experience> experienceList;
  List<Certificate> certificateList;

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

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
      city: json['city'],
      country: json['country'],
      profession: json['profession'],
      bio: json['bio'],
      educationList: (json['educationList'] as List)
          .map((e) => Education.fromJson(e))
          .toList(),
      experienceList: (json['experienceList'] as List)
          .map((e) => Experience.fromJson(e))
          .toList(),
      certificateList: (json['certificateList'] as List)
          .map((e) => Certificate.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
  }
}
