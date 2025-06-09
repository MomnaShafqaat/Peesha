class JobApplication {
  final String id;
  final String jobId;
  final String employeeId;
  final DateTime appliedAt;
  final String status; // e.g., 'Pending', 'Accepted', 'Rejected'

  JobApplication({
    required this.id,
    required this.jobId,
    required this.employeeId,
    required this.appliedAt,
    this.status = 'Pending',
  });

  Map<String, dynamic> toJson() => {
    '_id': id,
    'jobId': jobId,
    'employeeId': employeeId,
    'appliedAt': appliedAt.toIso8601String(),
    'status': status,
  };

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['_id'],
      jobId: json['jobId'],
      employeeId: json['employeeId'],
      appliedAt: DateTime.parse(json['appliedAt']),
      status: json['status'] ?? 'Pending',
    );
  }
}
