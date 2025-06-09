class Certificate {
  String title;
  String organization;
  String issueDate;
  String expiryDate;
  String certificateUrl; // optional download or view URL from Firebase Storage

  Certificate({
    required this.title,
    required this.organization,
    required this.issueDate,
    required this.expiryDate,
    required this.certificateUrl,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      title: json['title'],
      organization: json['organization'],
      issueDate: json['issueDate'],
      expiryDate: json['expiryDate'],
      certificateUrl: json['certificateUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'organization': organization,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
      'certificateUrl': certificateUrl,
    };
  }
}
