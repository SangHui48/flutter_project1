import 'package:flutter/material.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isForeigner = false;

  // 파일 업로드는 실제 구현 대신 버튼만 표시
  String? idCardFile;
  String? certificateFile;
  String? completionFile;
  String? passportFile;
  String? otherDocFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: const Color(0xFF002B5B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '주민등록번호',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '생년월일',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '휴대폰 번호',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              const Text('서류 업로드', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                child: Text(idCardFile == null ? '신분증 업로드' : '신분증 업로드 완료'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                child: Text(completionFile == null ? '이수증 업로드' : '이수증 업로드 완료'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                child: Text(certificateFile == null ? '자격증 업로드' : '자격증 업로드 완료'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Switch(
                    value: isForeigner,
                    onChanged: (val) {
                      setState(() {
                        isForeigner = val;
                      });
                    },
                  ),
                  const Text('외국인입니다'),
                ],
              ),
              if (isForeigner) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(passportFile == null ? '여권 업로드' : '여권 업로드 완료'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(otherDocFile == null ? '기타 현장 서류 업로드' : '기타 현장 서류 업로드 완료'),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002B5B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // 제출 로직
                },
                child: const Text(
                  '회원가입 완료',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 