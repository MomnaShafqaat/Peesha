class Education {
  final String level; // SSC, HSSC, O Levels, A Levels, Bachelor's, etc.
  final String instituteName;
  final String boardOrUniversity; // BISE, Cambridge, University name
  final String country; // Pakistan, UK, USA, etc.
  final String fieldOfStudy; // Science, Pre-Medical, Arts, etc.
  final String startDate;
  final String endDate;
  final String result; // Grade, GPA, Percentage, etc.
  final bool isOngoing; // true if still studying
  final bool isInternational; // true for foreign/international education

  Education({
    required this.level,
    required this.instituteName,
    required this.boardOrUniversity,
    required this.country,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    required this.result,
    this.isOngoing = false,
    this.isInternational = false,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      level: json['level'],
      instituteName: json['instituteName'],
      boardOrUniversity: json['boardOrUniversity'],
      country: json['country'],
      fieldOfStudy: json['fieldOfStudy'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      result: json['result'],
      isOngoing: json['isOngoing'] ?? false,
      isInternational: json['isInternational'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'instituteName': instituteName,
      'boardOrUniversity': boardOrUniversity,
      'country': country,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate,
      'endDate': endDate,
      'result': result,
      'isOngoing': isOngoing,
      'isInternational': isInternational,
    };
  }
}
