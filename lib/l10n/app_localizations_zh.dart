// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'ODDO';

  @override
  String get jobListTitle => '职位列表';

  @override
  String get applyButton => '申请';

  @override
  String get loadingJobs => '正在加载职位...';

  @override
  String get failedToLoadJobs => '加载职位失败';

  @override
  String get noJobsAvailable => '暂无职位';

  @override
  String get idLabel => '账号';

  @override
  String get passwordLabel => '密码';

  @override
  String get signUpButton => '注册';

  @override
  String get loginButton => '登录';

  @override
  String get nameLabel => '姓名';
  @override
  String get phoneOrEmailLabel => '手机号或邮箱';
  @override
  String get isForeignerLabel => '我是外国人';
  @override
  String get visaExpirationDateLabel => '签证到期日';
  @override
  String get selectDateLabel => '选择日期';
  @override
  String get nextButton => '下一步';
}
