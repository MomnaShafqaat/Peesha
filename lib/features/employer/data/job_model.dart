class Job {
  final String? id;
  final String title;
  final String description;
  final String requirements;
  final String location;
  final String salary;
  final String jobType;
  final String experienceLevel;
  final String employerId;
  final String employerName;
  final DateTime postedDate;
  final DateTime deadline;

  Job({
    this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.experienceLevel,
    required this.employerId,
    required this.employerName,
    required this.postedDate,
    required this.deadline,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'requirements': requirements,
      'location': location,
      'salary': salary,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'employerId': employerId,
      'employerName': employerName,
      'postedDate': postedDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
    };
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      requirements: json['requirements'],
      location: json['location'],
      salary: json['salary'],
      jobType: json['jobType'],
      experienceLevel: json['experienceLevel'],
      employerId: json['employerId'],
      employerName: json['employerName'],
      postedDate: DateTime.parse(json['postedDate']),
      deadline: DateTime.parse(json['deadline']),
    );
  }
  Job copyWith({
    String? title,
    String? description,
    String? requirements,
    String? location,
    String? salary,
    String? jobType,
    String? experienceLevel,
    DateTime? postedDate,
    DateTime? deadline,
  }) {
    return Job(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      employerId: employerId,
      employerName: employerName,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
    );
  }
}