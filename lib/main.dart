import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'constants/app_constants.dart';
import 'controllers/auth_controller.dart';
import 'controllers/job_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/work_log_controller.dart';
import 'screens/intro_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const ODDOApp());
}

class ODDOApp extends StatelessWidget {
  const ODDOApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX 컨트롤러 초기화
    Get.put(AuthController());
    Get.put(JobController());
    Get.put(ProfileController());
    Get.put(WorkLogController());

    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // 테마 설정
      theme: ThemeData(
        // fontFamily: 'Pretendard',
        primaryColor: Color(AppConstants.primaryColorHex),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(AppConstants.primaryColorHex),
          primary: Color(AppConstants.primaryColorHex),
          secondary: Color(AppConstants.accentColorHex),
        ),
        scaffoldBackgroundColor: Color(AppConstants.backgroundColorHex),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(AppConstants.primaryColorHex),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(AppConstants.primaryColorHex),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, AppConstants.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontSize: AppConstants.largeFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(AppConstants.primaryColorHex),
            textStyle: TextStyle(
              fontSize: AppConstants.mediumFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(AppConstants.grayColorHex),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(AppConstants.grayColorHex),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(AppConstants.primaryColorHex),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppConstants.mediumPadding,
            vertical: AppConstants.mediumPadding,
          ),
          hintStyle: TextStyle(
            color: Color(AppConstants.grayColorHex),
            fontSize: AppConstants.mediumFontSize,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
      ),
      
      // 다국어 지원
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
        const Locale('zh', 'CN'),
        const Locale('vi', 'VN'),
      ],
      locale: const Locale('ko', 'KR'),
      
      // 초기 라우트 설정
      home: const AppWrapper(),
    );
  }
}

// 앱 래퍼 - 로그인 상태에 따라 화면 분기
class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Obx(() {
      if (authController.isLoggedIn.value) {
        return const MainScreen();
      } else {
        return const IntroScreen();
      }
    });
  }
}
