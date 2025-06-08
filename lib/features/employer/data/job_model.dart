/*  // Add this named constructor in job_model.dart
  factory Job.fromRestApi(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? '',  // or whatever your backend ID field is
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      employerId: json['employerId'] ?? '',
      employerName: json['employerName'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      datePosted: json['datePosted'] ?? '',
      dateDeadline: json['dateDeadline'] ?? '',

    );
  }*/
class Job {
  final String id;
  final String title;
  final String description;
  final String location;
  final String salary;
  final String jobType;
  final String experienceLevel;
  final String employerId;
  final String employerName;
  final String datePosted;
  final String dateDeadline;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.experienceLevel,
    required this.employerId,
    required this.employerName,
    required this.datePosted,
    required this.dateDeadline,
  });

  factory Job.fromJson(Map<String, dynamic> json, String id) {
    return Job(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      jobType: json['jobType'] ?? '',
      experienceLevel: json['experienceLevel'] ?? '',
      employerId: json['employerId'] ?? '',
      employerName: json['employerName'] ?? '',
      datePosted: json['datePosted'] ?? '',
      dateDeadline: json['dateDeadline'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'salary': salary,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'employerId': employerId,
      'employerName': employerName,
      'datePosted': datePosted,
      'dateDeadline': dateDeadline,
    };
  }

  factory Job.fromRestApi(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      jobType: json['jobType'] ?? '',
      experienceLevel: json['experienceLevel'] ?? '',
      employerId: json['employerId'] ?? '',
      employerName: json['employerName'] ?? '',
      datePosted: json['datePosted'] ?? '',
      dateDeadline: json['dateDeadline'] ?? '',
    );}

  Job copyWith({
    String? title,
    String? description,
    String? location,
    String? salary,
    String? jobType,
    String? experienceLevel,
    String? datePosted,
    String? dateDeadline,
  }) {
    return Job(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      employerId: employerId,
      employerName: employerName,
      datePosted: datePosted ?? this.datePosted,
      dateDeadline: dateDeadline ?? this.dateDeadline,
    );
  }
}
