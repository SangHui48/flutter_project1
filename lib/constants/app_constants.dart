// ODDO 앱에서 사용하는 상수들을 정의하는 파일
class AppConstants {
  // 색상 상수
  static const int primaryColorHex = 0xFF1E2A4B; // #1E2A4B
  static const int accentColorHex = 0xFFFFD700; // #FFD700
  static const int backgroundColorHex = 0xFFFFFFFF; // 흰색 배경
  static const int textColorHex = 0xFF1E2A4B; // 텍스트 색상
  static const int grayColorHex = 0xFF6B7280; // 회색
  
  // 폰트 크기
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 16.0;
  static const double largeFontSize = 18.0;
  static const double titleFontSize = 24.0;
  static const double headlineFontSize = 32.0;
  
  // 패딩 및 마진
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // 버튼 높이
  static const double buttonHeight = 56.0;
  static const double smallButtonHeight = 44.0;
  
  // 카드 높이
  static const double cardHeight = 120.0;
  static const double jobCardHeight = 160.0;
  
  // 앱 이름
  static const String appName = 'ODDO';
  
  // 지원 언어
  static const List<String> supportedLanguages = ['ko', 'zh', 'vi'];
  static const List<String> supportedLanguageNames = ['한국어', '中文', 'Tiếng Việt'];
  
  // 국가 코드
  static const Map<String, String> countryCodes = {
    'KR': '+82',
    'CN': '+86',
    'VN': '+84',
    'TH': '+66',
    'PH': '+63',
  };
  
  // 기술 목록
  static const List<Map<String, dynamic>> skills = [
    {'id': 'carpenter', 'name': '목수', 'icon': '🔨'},
    {'id': 'plasterer', 'name': '미장', 'icon': '🧱'},
    {'id': 'rebar', 'name': '철근', 'icon': '🔩'},
    {'id': 'concrete', 'name': '콘크리트', 'icon': '🏗️'},
    {'id': 'electrician', 'name': '전기', 'icon': '⚡'},
    {'id': 'plumber', 'name': '배관', 'icon': '🔧'},
    {'id': 'painter', 'name': '도장', 'icon': '🎨'},
    {'id': 'welder', 'name': '용접', 'icon': '🔥'},
  ];
  
  // 비자 종류
  static const List<String> visaTypes = [
    'E-9 비자',
    'E-7 비자',
    'F-4 비자',
    '기타',
  ];
  
  // 작업 상태
  static const Map<String, String> workStatus = {
    'pending': '작업 완료 대기',
    'completed': '지급 완료',
    'in_progress': '작업 중',
  };
}
