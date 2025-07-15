import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // 회원가입 필드 변수
  String? id;
  String? name;
  String? phoneOrEmail;
  bool isForeigner = false;
  DateTime? visaExpirationDate;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.idLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => id = val,
                validator: (val) => val == null || val.isEmpty ? "${AppLocalizations.of(context)!.idLabel}를 입력하세요" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.nameLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => name = val,
                validator: (val) => val == null || val.isEmpty ? "${AppLocalizations.of(context)!.nameLabel}을 입력하세요" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phoneOrEmailLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) => phoneOrEmail = val,
                validator: (val) => val == null || val.isEmpty ? "${AppLocalizations.of(context)!.phoneOrEmailLabel}을 입력하세요" : null,
              ),
              const SizedBox(height: 16),
              // 한국어가 아닐 때만 외국인 토글 및 비자 만료일 노출
              if (locale.languageCode != 'ko') ...[
                Row(
                  children: [
                    Switch(
                      value: isForeigner,
                      onChanged: (val) {
                        setState(() {
                          isForeigner = val;
                          if (!val) visaExpirationDate = null;
                        });
                      },
                    ),
                    Text(AppLocalizations.of(context)!.isForeignerLabel),
                  ],
                ),
                if (isForeigner) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => visaExpirationDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.visaExpirationDateLabel,
                        border: const OutlineInputBorder(),
                      ),
                      child: Text(
                        visaExpirationDate == null
                            ? AppLocalizations.of(context)!.selectDateLabel
                            : visaExpirationDate!.toIso8601String().split('T').first,
                        style: TextStyle(
                          color: visaExpirationDate == null ? Colors.grey : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
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
                  if (_formKey.currentState?.validate() ?? false) {
                    // TODO: 다음 회원가입 페이지로 이동 (입력값 전달)
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