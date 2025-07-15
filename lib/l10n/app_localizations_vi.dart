// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'ODDO';

  @override
  String get jobListTitle => 'Danh Sách Việc Làm';

  @override
  String get applyButton => 'Ứng tuyển';

  @override
  String get loadingJobs => 'Đang tải công việc...';

  @override
  String get failedToLoadJobs => 'Không tải được công việc';

  @override
  String get noJobsAvailable => 'Không có công việc nào';

  @override
  String get idLabel => 'ID';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get signUpButton => 'Đăng ký';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get nameLabel => 'Tên';
  @override
  String get phoneOrEmailLabel => 'Số điện thoại hoặc Email';
  @override
  String get isForeignerLabel => 'Tôi là người nước ngoài';
  @override
  String get visaExpirationDateLabel => 'Ngày hết hạn visa';
  @override
  String get selectDateLabel => 'Chọn ngày';
  @override
  String get nextButton => 'Tiếp theo';
}
