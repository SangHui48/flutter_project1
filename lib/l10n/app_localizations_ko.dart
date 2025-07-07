// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Linklab';

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
}
