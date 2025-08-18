import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import 'main_screen.dart';

class LoginWithPasswordScreen extends StatefulWidget {
  const LoginWithPasswordScreen({super.key});

  @override
  State<LoginWithPasswordScreen> createState() => _LoginWithPasswordScreenState();
}

class _LoginWithPasswordScreenState extends State<LoginWithPasswordScreen> {
  final AuthController auth = Get.find<AuthController>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('휴대폰 번호와 비밀번호를 입력하세요',
                style: TextStyle(fontSize: AppConstants.mediumFontSize)),
            SizedBox(height: AppConstants.mediumPadding),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: '휴대폰 번호'),
            ),
            SizedBox(height: AppConstants.mediumPadding),
            TextField(
              controller: passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: '비밀번호',
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            SizedBox(height: AppConstants.largePadding),
            ElevatedButton(
              onPressed: () async {
                // TODO: 서버 로그인 (휴대폰+비번)
                final ok = await auth.login();
                if (ok) {
                  Get.offAll(() => const MainScreen());
                } else {
                  Get.snackbar('로그인 실패', '정보를 확인하세요',
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}


