// 사용자 정보를 관리하는 모델 클래스
class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final List<String> skills;
  final bool isAvailableToday;
  final bool isTeamLeader; // 팀장 권한 여부
  final String? visaType;
  final String? countryCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.skills,
    required this.isAvailableToday,
    this.isTeamLeader = false,
    this.visaType,
    this.countryCode,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON에서 UserModel 객체로 변환하는 팩토리 생성자
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      skills: List<String>.from(json['skills'] ?? []),
      isAvailableToday: json['isAvailableToday'] ?? false,
      isTeamLeader: json['isTeamLeader'] ?? false,
      visaType: json['visaType'],
      countryCode: json['countryCode'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // UserModel 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'skills': skills,
      'isAvailableToday': isAvailableToday,
      'isTeamLeader': isTeamLeader,
      'visaType': visaType,
      'countryCode': countryCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // 사용자 정보를 복사하여 새로운 객체를 생성하는 메서드
  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    List<String>? skills,
    bool? isAvailableToday,
    bool? isTeamLeader,
    String? visaType,
    String? countryCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      skills: skills ?? this.skills,
      isAvailableToday: isAvailableToday ?? this.isAvailableToday,
      isTeamLeader: isTeamLeader ?? this.isTeamLeader,
      visaType: visaType ?? this.visaType,
      countryCode: countryCode ?? this.countryCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
