// 작업 완료 기록을 관리하는 모델 클래스
class WorkLogModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String employerName;
  final String location;
  final DateTime workDate;
  final int dailyWage;
  final String status; // 'in_progress', 'pending', 'completed'
  final DateTime? completedAt;
  final DateTime? paidAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkLogModel({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.employerName,
    required this.location,
    required this.workDate,
    required this.dailyWage,
    required this.status,
    this.completedAt,
    this.paidAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON에서 WorkLogModel 객체로 변환하는 팩토리 생성자
  factory WorkLogModel.fromJson(Map<String, dynamic> json) {
    return WorkLogModel(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      employerName: json['employerName'] ?? '',
      location: json['location'] ?? '',
      workDate: DateTime.parse(json['workDate'] ?? DateTime.now().toIso8601String()),
      dailyWage: json['dailyWage'] ?? 0,
      status: json['status'] ?? 'in_progress',
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // WorkLogModel 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'employerName': employerName,
      'location': location,
      'workDate': workDate.toIso8601String(),
      'dailyWage': dailyWage,
      'status': status,
      'completedAt': completedAt?.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // 작업 기록을 복사하여 새로운 객체를 생성하는 메서드
  WorkLogModel copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? employerName,
    String? location,
    DateTime? workDate,
    int? dailyWage,
    String? status,
    DateTime? completedAt,
    DateTime? paidAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkLogModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      employerName: employerName ?? this.employerName,
      location: location ?? this.location,
      workDate: workDate ?? this.workDate,
      dailyWage: dailyWage ?? this.dailyWage,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      paidAt: paidAt ?? this.paidAt,
      notes: notes ?? this.notes,
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

  // 작업일을 포맷팅하는 메서드
  String get formattedWorkDate {
    return '${workDate.month}월 ${workDate.day}일';
  }

  // 상태를 한글로 표시하는 메서드
  String get statusText {
    switch (status) {
      case 'in_progress':
        return '작업 중';
      case 'pending':
        return '작업 완료 대기';
      case 'completed':
        return '지급 완료';
      default:
        return '알 수 없음';
    }
  }

  // 상태에 따른 색상을 반환하는 메서드
  int get statusColor {
    switch (status) {
      case 'in_progress':
        return 0xFFFFA500; // 주황색
      case 'pending':
        return 0xFFFFD700; // 노란색
      case 'completed':
        return 0xFF4CAF50; // 초록색
      default:
        return 0xFF6B7280; // 회색
    }
  }
}
