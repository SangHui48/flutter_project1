import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import 'country_selection_screen.dart';

// 인트로 화면
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 로고 애니메이션 컨트롤러
    _logoController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    // 페이드 애니메이션 컨트롤러
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    // 로고 스케일 애니메이션
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    // 페이드 애니메이션
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    // 애니메이션 시작
    _startAnimation();
  }

  void _startAnimation() async {
    // 로고 애니메이션 시작
    _logoController.forward();
    
    // 2초 후 페이드 애니메이션 시작
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      _fadeController.forward();
    }
    
    // 3초 후 국가 선택 화면으로 이동
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      Get.off(() => const CountrySelectionScreen());
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppConstants.primaryColorHex),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 애니메이션
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: AppConstants.headlineFontSize,
                          fontWeight: FontWeight.bold,
                          color: Color(AppConstants.primaryColorHex),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: AppConstants.largePadding),
            
            // 앱 설명 텍스트 (페이드 애니메이션)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        '건설 현장 일자리 매칭',
                        style: TextStyle(
                          fontSize: AppConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: AppConstants.smallPadding),
                      Text(
                        '안전하고 신뢰할 수 있는 건설 일자리를 찾아보세요',
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
