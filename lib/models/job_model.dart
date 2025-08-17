// 일자리 공고 정보를 관리하는 모델 클래스
class JobModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> requiredSkills;
  final int dailyWage;
  final String employerName;
  final String employerPhone;
  final DateTime startDate;
  final DateTime? endDate;
  final int duration; // 작업 기간 (일)
  final String status; // 'active', 'closed', 'completed'
  final bool isApplied; // 사용자가 지원했는지 여부
  final DateTime createdAt;
  final DateTime updatedAt;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.requiredSkills,
    required this.dailyWage,
    required this.employerName,
    required this.employerPhone,
    required this.startDate,
    this.endDate,
    required this.duration,
    required this.status,
    required this.isApplied,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON에서 JobModel 객체로 변환하는 팩토리 생성자
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      dailyWage: json['dailyWage'] ?? 0,
      employerName: json['employerName'] ?? '',
      employerPhone: json['employerPhone'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      duration: json['duration'] ?? 1,
      status: json['status'] ?? 'active',
      isApplied: json['isApplied'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // JobModel 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'requiredSkills': requiredSkills,
      'dailyWage': dailyWage,
      'employerName': employerName,
      'employerPhone': employerPhone,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'duration': duration,
      'status': status,
      'isApplied': isApplied,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // 일자리 정보를 복사하여 새로운 객체를 생성하는 메서드
  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? requiredSkills,
    int? dailyWage,
    String? employerName,
    String? employerPhone,
    DateTime? startDate,
    DateTime? endDate,
    int? duration,
    String? status,
    bool? isApplied,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      dailyWage: dailyWage ?? this.dailyWage,
      employerName: employerName ?? this.employerName,
      employerPhone: employerPhone ?? this.employerPhone,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      isApplied: isApplied ?? this.isApplied,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 일당을 포맷팅하는 메서드
  String get formattedWage {
    return '${dailyWage.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},'
    )}원';
  }

  // 시작일을 포맷팅하는 메서드
  String get formattedStartDate {
    return '${startDate.month}월 ${startDate.day}일';
  }

  // 작업 기간을 포맷팅하는 메서드
  String get formattedDuration {
    return duration == 1 ? '1일' : '${duration}일';
  }
}
