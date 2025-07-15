// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ODDO';

  @override
  String get jobListTitle => 'Job List';

  @override
  String get applyButton => 'Apply';

  @override
  String get loadingJobs => 'Loading jobs...';

  @override
  String get failedToLoadJobs => 'Failed to load jobs';

  @override
  String get noJobsAvailable => 'No jobs available';

  @override
  String get idLabel => 'ID';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get loginButton => 'Login';

  @override
  String get nameLabel => 'Name';
  @override
  String get phoneOrEmailLabel => 'Phone or Email';
  @override
  String get isForeignerLabel => 'I am a foreigner';
  @override
  String get visaExpirationDateLabel => 'Visa Expiration Date';
  @override
  String get selectDateLabel => 'Select date';
  @override
  String get nextButton => 'Next';
}
