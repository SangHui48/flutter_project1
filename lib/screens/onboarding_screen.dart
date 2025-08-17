import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'main_screen.dart';

// 시작 및 로그인 화면
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  
  bool showLoginForm = false;
  bool showVisaSelection = false;
  bool showSmsForm = false;

  @override
  void initState() {
    super.initState();
    // 휴대폰 번호 변경 리스너
    phoneController.addListener(() {
      authController.setPhoneNumber(phoneController.text);
    });
    
    // SMS 코드 변경 리스너
    smsController.addListener(() {
      authController.setSmsCode(smsController.text);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              // 로고 영역
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ODDO 로고
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(AppConstants.primaryColorHex),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: AppConstants.headlineFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppConstants.largePadding),
                      Text(
                        '건설 현장 일자리 매칭',
                        style: TextStyle(
                          fontSize: AppConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: Color(AppConstants.textColorHex),
                        ),
                      ),
                      SizedBox(height: AppConstants.smallPadding),
                      Text(
                        '안전하고 신뢰할 수 있는 건설 일자리를 찾아보세요',
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          color: Color(AppConstants.grayColorHex),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // 역할 선택 또는 로그인 폼
              Expanded(
                flex: 3,
                child: _buildCurrentForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 현재 폼 표시
  Widget _buildCurrentForm() {
    if (!showLoginForm) {
      return _buildRoleSelection();
    } else if (authController.isForeigner.value && !showVisaSelection) {
      return _buildVisaSelection();
    } else if (!showSmsForm) {
      return _buildPhoneLogin();
    } else {
      return _buildSmsVerification();
    }
  }

  // 역할 선택 위젯
  Widget _buildRoleSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ODDO에 오신 것을 환영합니다',
          style: TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.textColorHex),
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        Text(
          '건설 현장 일자리를 찾아보세요',
          style: TextStyle(
            fontSize: AppConstants.mediumFontSize,
            color: Color(AppConstants.grayColorHex),
          ),
        ),
        SizedBox(height: AppConstants.largePadding),
        
        // 구직자 버튼
        CustomButton(
          onPressed: () {
            authController.selectRole('jobseeker');
            setState(() {
              showLoginForm = true;
            });
          },
          text: '시작하기',
          icon: Icons.work,
          backgroundColor: Color(AppConstants.primaryColorHex),
        ),
      ],
    );
  }

  // 비자 선택 위젯
  Widget _buildVisaSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '비자 종류를 선택해주세요',
          style: TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.textColorHex),
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        Text(
          '서류 업로드를 위해 비자 종류를 선택해주세요',
          style: TextStyle(
            fontSize: AppConstants.mediumFontSize,
            color: Color(AppConstants.grayColorHex),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppConstants.largePadding),
        
        // 비자 종류 선택
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
          decoration: BoxDecoration(
            border: Border.all(color: Color(AppConstants.grayColorHex)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: authController.visaType.value.isEmpty ? null : authController.visaType.value,
              isExpanded: true,
              hint: Text('비자 종류를 선택하세요'),
              items: AppConstants.visaTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  authController.updateVisaType(value);
                }
              },
            ),
          ),
        ),
        
        SizedBox(height: AppConstants.largePadding),
        
        // 다음 버튼
        Obx(() => CustomButton(
          onPressed: authController.visaType.value.isNotEmpty
              ? () {
                  setState(() {
                    showVisaSelection = true;
                  });
                }
              : null,
          text: '다음',
          icon: Icons.arrow_forward,
        )),
      ],
    );
  }

  // 휴대폰 번호 로그인 위젯
  Widget _buildPhoneLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '휴대폰 번호로 로그인',
          style: TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.textColorHex),
          ),
        ),
        SizedBox(height: AppConstants.largePadding),
        
        // 국가 코드 선택
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
          decoration: BoxDecoration(
            border: Border.all(color: Color(AppConstants.grayColorHex)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: authController.countryCode.value,
              isExpanded: true,
              items: AppConstants.countryCodes.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(
                    '${entry.key} ${entry.value}',
                    style: TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      color: Color(AppConstants.textColorHex),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  authController.changeCountryCode(value);
                }
              },
            ),
          ),
        ),
        
        SizedBox(height: AppConstants.mediumPadding),
        
        // 휴대폰 번호 입력
        CustomTextField(
          controller: phoneController,
          hintText: '휴대폰 번호를 입력하세요',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone,
        ),
        
        SizedBox(height: AppConstants.largePadding),
        
        // SMS 인증 요청 버튼
        Obx(() => CustomButton(
          onPressed: authController.isValidPhoneNumber() && !authController.isLoading.value
              ? () async {
                  final success = await authController.requestSmsVerification();
                  if (success) {
                    setState(() {
                      showSmsForm = true;
                    });
                    Get.snackbar(
                      '인증번호 발송',
                      '휴대폰으로 인증번호가 발송되었습니다.',
                      backgroundColor: Color(AppConstants.accentColorHex),
                      colorText: Color(AppConstants.textColorHex),
                    );
                  } else {
                    Get.snackbar(
                      '오류',
                      '인증번호 발송에 실패했습니다.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              : null,
          text: authController.isLoading.value ? '발송 중...' : '인증번호 받기',
          icon: Icons.send,
        )),
        
        SizedBox(height: AppConstants.mediumPadding),
        
        // 뒤로가기 버튼
        TextButton(
          onPressed: () {
            setState(() {
              showLoginForm = false;
            });
          },
          child: Text('뒤로가기'),
        ),
      ],
    );
  }

  // SMS 인증 위젯
  Widget _buildSmsVerification() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '인증번호 확인',
          style: TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.textColorHex),
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        Text(
          '${authController.countryCode.value}${authController.phoneNumber.value}로 발송된\n인증번호를 입력하세요',
          style: TextStyle(
            fontSize: AppConstants.mediumFontSize,
            color: Color(AppConstants.grayColorHex),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppConstants.largePadding),
        
        // 인증번호 입력
        CustomTextField(
          controller: smsController,
          hintText: '인증번호 입력',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.security,
        ),
        
        SizedBox(height: AppConstants.largePadding),
        
        // 인증 확인 버튼
        Obx(() => CustomButton(
          onPressed: authController.isValidSmsCode() && !authController.isLoading.value
              ? () async {
                  final success = await authController.verifySmsCode();
                  if (success) {
                    final loginSuccess = await authController.login();
                    if (loginSuccess) {
                      Get.snackbar(
                        '로그인 성공',
                        'ODDO에 오신 것을 환영합니다!',
                        backgroundColor: Color(AppConstants.accentColorHex),
                        colorText: Color(AppConstants.textColorHex),
                      );
                      // 메인 화면으로 이동
                      Get.offAll(() => const MainScreen());
                    } else {
                      Get.snackbar(
                        '로그인 실패',
                        '로그인에 실패했습니다.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    Get.snackbar(
                      '인증 실패',
                      '인증번호가 올바르지 않습니다.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              : null,
          text: authController.isLoading.value ? '확인 중...' : '인증 확인',
          icon: Icons.check,
        )),
        
        SizedBox(height: AppConstants.mediumPadding),
        
        // 인증번호 재발송
        TextButton(
          onPressed: () async {
            final success = await authController.requestSmsVerification();
            if (success) {
              Get.snackbar(
                '재발송 완료',
                '인증번호가 재발송되었습니다.',
                backgroundColor: Color(AppConstants.accentColorHex),
                colorText: Color(AppConstants.textColorHex),
              );
            }
          },
          child: Text('인증번호 재발송'),
        ),
        
        SizedBox(height: AppConstants.smallPadding),
        
        // 뒤로가기 버튼
        TextButton(
          onPressed: () {
            setState(() {
              showSmsForm = false;
            });
          },
          child: Text('뒤로가기'),
        ),
      ],
    );
  }
}
