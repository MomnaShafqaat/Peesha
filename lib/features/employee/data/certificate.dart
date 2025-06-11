class Certificate {
  final String title;
  final String organization;
  final String issueDate;
  final String expiryDate;
  final String certificateUrl;

  Certificate({
    required this.title,
    required this.organization,
    required this.issueDate,
    required this.expiryDate,
    required this.certificateUrl,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    title: json['title'],
    organization: json['organization'],
    issueDate: json['issueDate'],
    expiryDate: json['expiryDate'],
    certificateUrl: json['certificateUrl'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'organization': organization,
    'issueDate': issueDate,
    'expiryDate': expiryDate,
    'certificateUrl': certificateUrl,
  };

  factory Certificate.empty() => Certificate(
    title: '',
    organization: '',
    issueDate: '',
    expiryDate: '',
    certificateUrl: '',
  );
}
