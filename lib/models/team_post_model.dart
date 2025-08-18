// 팀 단위 공고 정보를 관리하는 모델 클래스
class TeamPostModel {
  final String id;
  final String title;
  final String location; // 근무지 (오프라인/온라인 여부 포함 가능)
  final String workRole; // 담당 업무
  final String description;
  final String teamLeaderName;
  final String teamLeaderPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  TeamPostModel({
    required this.id,
    required this.title,
    required this.location,
    required this.workRole,
    required this.description,
    required this.teamLeaderName,
    required this.teamLeaderPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeamPostModel.fromJson(Map<String, dynamic> json) {
    return TeamPostModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      workRole: json['workRole'] ?? '',
      description: json['description'] ?? '',
      teamLeaderName: json['teamLeaderName'] ?? '',
      teamLeaderPhone: json['teamLeaderPhone'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'workRole': workRole,
      'description': description,
      'teamLeaderName': teamLeaderName,
      'teamLeaderPhone': teamLeaderPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TeamPostModel copyWith({
    String? id,
    String? title,
    String? location,
    String? workRole,
    String? description,
    String? teamLeaderName,
    String? teamLeaderPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TeamPostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      workRole: workRole ?? this.workRole,
      description: description ?? this.description,
      teamLeaderName: teamLeaderName ?? this.teamLeaderName,
      teamLeaderPhone: teamLeaderPhone ?? this.teamLeaderPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


