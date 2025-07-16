import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'sign_up_attachment_screen.dart'; // Added import for SignUpAttachmentScreen

class SignUpFormScreen extends StatefulWidget {
  final Map<String, dynamic> selectedCountry;
  const SignUpFormScreen({super.key, required this.selectedCountry});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // 회원가입 필드 변수
  String? id;
  String? password;
  String? name;
  String? rrn;
  String? phone;
  String? email;
  String? phoneOrEmail;
  bool isForeigner = false;
  DateTime? visaExpirationDate;
  String? idImagePath;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isKorea = widget.selectedCountry['locale']?.languageCode == 'ko';
    // Localization helpers for new fields
    final rrnLabel = AppLocalizations.of(context)?.rrnLabel ?? '주민등록번호';
    final phoneLabel = AppLocalizations.of(context)?.phoneLabel ?? '휴대폰 번호';
    final emailLabel = AppLocalizations.of(context)?.emailLabel ?? '이메일';
    final visaTypeLabel = AppLocalizations.of(context)?.visaTypeLabel ?? '비자 종류';
    final visaExpiryLabel = AppLocalizations.of(context)?.visaExpirationDateLabel ?? '비자 만료일';
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signUpButton),
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
              // 한국, 중국, 영어권 모두 동일한 기본 항목
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.idLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => id = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.passwordLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => password = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.nameLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => name = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: rrnLabel,
                  hintText: rrnLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => rrn = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: phoneLabel,
                  hintText: phoneLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => phone = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: emailLabel,
                  hintText: emailLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => email = val,
              ),
              const SizedBox(height: 16),
              // 중국/영어권만 비자, 비자만료일 추가
              if (!isKorea) ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: visaTypeLabel,
                    hintText: visaTypeLabel,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    // TODO: 비자 종류 저장
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        visaExpirationDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: visaExpiryLabel,
                      hintText: visaExpiryLabel,
                      border: const OutlineInputBorder(),
                    ),
                    child: Text(
                      visaExpirationDate == null
                          ? (AppLocalizations.of(context)?.selectDateLabel ?? '날짜 선택')
                          : visaExpirationDate!.toIso8601String().split('T').first,
                      style: TextStyle(
                        color: visaExpirationDate == null ? Colors.grey : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                  final lang = widget.selectedCountry['locale']?.languageCode;
                  if (lang == 'ko' || lang == 'zh' || lang == 'en') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SignUpAttachmentScreen(selectedCountry: widget.selectedCountry),
                      ),
                    );
                  } else {
                    // TODO: 기타 국가 처리
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.nextButton,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 