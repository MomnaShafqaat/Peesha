import 'package:cloud_firestore/cloud_firestore.dart';

class Employer {
  String? id;
   String companyName;
   String industry;
   String companySize; // e.g., Small, Medium, Large
   String location;
   String address;
   String city;
   String state;
   String country;
   String postalCode;
   String contactEmail;
   String contactPhone;
   String contactPersonName;
   String about;
   String website;
   String logoUrl;
   String coverImageUrl;
   List<String> socialMediaLinks;
   DateTime foundedDate;
   List<String> jobPostings;
   List<String> benefits;
   String companyType; // e.g., Corporation, Startup, NGO
   bool isVerified;
   DateTime createdAt;
   DateTime updatedAt;

  Employer({
    this.id,
    required this.companyName,
    required this.industry,
    required this.companySize,
    required this.location,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.contactEmail,
    required this.contactPhone,
    required this.contactPersonName,
    required this.about,
    required this.website,
    this.logoUrl = '',
    this.coverImageUrl = '',
    this.socialMediaLinks = const [],
    required this.foundedDate,
    this.jobPostings = const [],
    this.benefits = const [],
    required this.companyType,
    this.isVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      id: json['_id'],
      companyName: json['companyName'] ?? json['company_name'] ?? '',
      industry: json['industry'] ?? '',
      companySize: json['companySize'] ?? '',
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? json['contact_phone'] ?? '',
      contactPersonName: json['contactPersonName'] ?? '',
      about: json['about'] ?? '',
      website: json['website'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      socialMediaLinks: List<String>.from(json['socialMediaLinks'] ?? []),
      foundedDate: (json['foundedDate'] is Timestamp)
          ? (json['foundedDate'] as Timestamp).toDate()
          : DateTime.tryParse(json['foundedDate'] ?? '') ?? DateTime.now(),
      jobPostings: List<String>.from(json['jobPostings'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      companyType: json['companyType'] ?? '',
      isVerified: json['isVerified'] ?? false,
      createdAt: (json['createdAt'] is Timestamp)
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: (json['updatedAt'] is Timestamp)
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'companyName': companyName,
      'industry': industry,
      'companySize': companySize,
      'location': location,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'contactPersonName': contactPersonName,
      'about': about,
      'website': website,
      'logoUrl': logoUrl,
      'coverImageUrl': coverImageUrl,
      'socialMediaLinks': socialMediaLinks,
      'foundedDate': foundedDate.toIso8601String(),
      'jobPostings': jobPostings,
      'benefits': benefits,
      'companyType': companyType,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Employer copyWith({
    String? companyName,
    String? industry,
    String? companySize,
    String? location,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? contactEmail,
    String? contactPhone,
    String? contactPersonName,
    String? about,
    String? website,
    String? logoUrl,
    String? coverImageUrl,
    List<String>? socialMediaLinks,
    DateTime? foundedDate,
    List<String>? jobPostings,
    List<String>? benefits,
    String? companyType,
    bool? isVerified,
  }) {
    return Employer(
      id: id,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      companySize: companySize ?? this.companySize,
      location: location ?? this.location,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      about: about ?? this.about,
      website: website ?? this.website,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      foundedDate: foundedDate ?? this.foundedDate,
      jobPostings: jobPostings ?? this.jobPostings,
      benefits: benefits ?? this.benefits,
      companyType: companyType ?? this.companyType,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
