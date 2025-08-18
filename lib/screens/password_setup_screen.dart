import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import 'main_screen.dart';

class PasswordSetupScreen extends StatefulWidget {
  const PasswordSetupScreen({super.key});

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 설정'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.largePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${auth.countryCode.value}${auth.phoneNumber.value} 계정의 비밀번호를 설정하세요',
                style: TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  color: Color(AppConstants.textColorHex),
                ),
              ),
              SizedBox(height: AppConstants.largePadding),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscure1,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '비밀번호를 입력하세요';
                  if (v.trim().length < 6) return '6자 이상 입력하세요';
                  return null;
                },
              ),
              SizedBox(height: AppConstants.mediumPadding),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscure2,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '비밀번호를 다시 입력하세요';
                  if (v.trim() != _passwordController.text.trim()) return '비밀번호가 일치하지 않습니다';
                  return null;
                },
              ),
              SizedBox(height: AppConstants.largePadding),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final ok = await auth.completeRegistrationWithPassword(_passwordController.text.trim());
                  if (ok) {
                    Get.offAll(() => const MainScreen());
                    Get.snackbar(
                      '가입 완료',
                      '비밀번호가 설정되었습니다. 환영합니다!',
                      backgroundColor: Color(AppConstants.accentColorHex),
                      colorText: Color(AppConstants.textColorHex),
                    );
                  } else {
                    Get.snackbar(
                      '오류',
                      '잠시 후 다시 시도하세요.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text('완료'),
              )
            ],
          ),
        ),
      ),
    );
  }
}


