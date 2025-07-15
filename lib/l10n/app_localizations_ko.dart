// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'ODDO';

  @override
  String get jobListTitle => '일자리 목록';

  @override
  String get applyButton => '지원하기';

  @override
  String get loadingJobs => '일자리를 불러오는 중...';

  @override
  String get failedToLoadJobs => '일자리를 불러오지 못했습니다';

  @override
  String get noJobsAvailable => '등록된 일자리가 없습니다';

  @override
  String get idLabel => '아이디';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get signUpButton => '회원가입';

  @override
  String get loginButton => '로그인';

  @override
  String get nameLabel => '이름';
  @override
  String get phoneOrEmailLabel => '휴대폰 번호 또는 이메일';
  @override
  String get isForeignerLabel => '외국인입니다';
  @override
  String get visaExpirationDateLabel => '비자 만료일';
  @override
  String get selectDateLabel => '날짜 선택';
  @override
  String get nextButton => '다음';
}
