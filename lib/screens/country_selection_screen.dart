import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import 'onboarding_screen.dart';

// 국가 선택 화면
class CountrySelectionScreen extends StatelessWidget {
  const CountrySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Color(AppConstants.backgroundColorHex),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              // 상단 로고
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(AppConstants.primaryColorHex),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: AppConstants.largeFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: AppConstants.extraLargePadding),
              
              // 제목
              Text(
                '국가를 선택해주세요',
                style: TextStyle(
                  fontSize: AppConstants.titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Color(AppConstants.textColorHex),
                ),
              ),
              
              SizedBox(height: AppConstants.smallPadding),
              
              Text(
                '서비스 이용을 위해 국가를 선택해주세요',
                style: TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  color: Color(AppConstants.grayColorHex),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppConstants.extraLargePadding),
              
              // 국가 선택
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 국가 선택 드롭다운
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(AppConstants.grayColorHex)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: null,
                            isExpanded: true,
                            hint: Text(
                              '국가를 선택하세요',
                              style: TextStyle(
                                fontSize: AppConstants.mediumFontSize,
                                color: Color(AppConstants.grayColorHex),
                              ),
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: 'KR',
                                child: Row(
                                  children: [
                                    Text('🇰🇷', style: TextStyle(fontSize: 20)),
                                    SizedBox(width: AppConstants.smallPadding),
                                    Text('대한민국'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'CN',
                                child: Row(
                                  children: [
                                    Text('🇨🇳', style: TextStyle(fontSize: 20)),
                                    SizedBox(width: AppConstants.smallPadding),
                                    Text('중국'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'OTHER',
                                child: Row(
                                  children: [
                                    Text('🌍', style: TextStyle(fontSize: 20)),
                                    SizedBox(width: AppConstants.smallPadding),
                                    Text('기타'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                _selectCountry(authController, value, value != 'KR');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  // 국가 선택 처리
  void _selectCountry(AuthController authController, String countryCode, bool isForeigner) {
    // 국가 코드 설정
    authController.changeCountryCode(AppConstants.countryCodes[countryCode] ?? '+82');
    
    // 외국인 여부 설정
    authController.setIsForeigner(isForeigner);
    
    // 온보딩 화면으로 이동
    Get.off(() => const OnboardingScreen());
  }
}
