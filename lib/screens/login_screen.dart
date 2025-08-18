import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
// import 'main_screen.dart';
import 'password_setup_screen.dart';

// 로그인 화면
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  
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
      appBar: AppBar(
        title: Text('로그인'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(AppConstants.textColorHex),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.largePadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 로고 영역
                          Flexible(
                            fit: FlexFit.loose,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color(AppConstants.primaryColorHex),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppConstants.appName,
                                        style: TextStyle(
                                          fontSize: AppConstants.titleFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppConstants.largePadding),
                                  Text(
                                    '휴대폰 번호로 로그인',
                                    style: TextStyle(
                                      fontSize: AppConstants.titleFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Color(AppConstants.textColorHex),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: AppConstants.mediumPadding),

                          // 로그인/인증 폼
                          Flexible(
                            fit: FlexFit.loose,
                            child: _buildCurrentForm(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 현재 폼 표시
  Widget _buildCurrentForm() {
    if (!showSmsForm) {
      return _buildPhoneLogin();
    } else {
      return _buildSmsVerification();
    }
  }

  // 휴대폰 번호 로그인 위젯
  Widget _buildPhoneLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                    // SMS 인증 성공 후: 비밀번호 설정 화면으로 이동
                    Get.to(() => const PasswordSetupScreen());
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
