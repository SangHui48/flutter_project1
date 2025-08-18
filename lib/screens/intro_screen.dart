import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import 'country_selection_screen.dart';
import '../controllers/auth_controller.dart';
import 'login_with_password_screen.dart';

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
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    
    // 하드웨어 가속화 강제 활성화
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // 로고 애니메이션 컨트롤러
    _logoController = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    
    // 페이드 애니메이션 컨트롤러
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 450),
      vsync: this,
    );
    
    // 로고 스케일 애니메이션 (더 부드러운 곡선 사용)
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));
    
    // 페이드 애니메이션
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // 애니메이션 시작 (약간의 지연 후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        _startAnimation();
      }
    });
  }

  void _startAnimation() async {
    if (_isDisposed) return;
    
    try {
      // 로고 애니메이션 시작
      await _logoController.forward();
      
      // 0.6초 후 페이드 애니메이션 시작 (더 빠르게)
      if (!_isDisposed) {
        await Future.delayed(Duration(milliseconds: 600));
        if (mounted && !_isDisposed) {
          await _fadeController.forward();
        }
      }
      
      // 1초 후 국가 선택 화면으로 이동 (더 빠르게)
      if (!_isDisposed) {
        await Future.delayed(Duration(milliseconds: 1000));
        if (mounted && !_isDisposed) {
          final auth = Get.find<AuthController>();
          if (auth.hasPassword.value) {
            Get.off(() => const LoginWithPasswordScreen());
          } else {
            Get.off(() => const CountrySelectionScreen());
          }
        }
      }
    } catch (e) {
      // 에러 발생 시 바로 다음 화면으로 이동
      if (mounted && !_isDisposed) {
        final auth = Get.find<AuthController>();
        if (auth.hasPassword.value) {
          Get.off(() => const LoginWithPasswordScreen());
        } else {
          Get.off(() => const CountrySelectionScreen());
        }
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppConstants.primaryColorHex),
      body: RepaintBoundary(
        child: Center(
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
                            color: Colors.black.withValues(alpha: 0.2),
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
                            color: Colors.white.withValues(alpha: 0.8),
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
      ),
    );
  }
}
