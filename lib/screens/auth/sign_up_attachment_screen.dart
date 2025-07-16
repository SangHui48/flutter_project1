import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class SignUpAttachmentScreen extends StatefulWidget {
  final Map<String, dynamic> selectedCountry;
  const SignUpAttachmentScreen({super.key, required this.selectedCountry});

  @override
  State<SignUpAttachmentScreen> createState() => _SignUpAttachmentScreenState();
}

class _SignUpAttachmentScreenState extends State<SignUpAttachmentScreen> {
  // Korean fields
  String? idCardPath;
  String? constructionCertPath;
  String? qualificationCertPath;
  bool hasPrePlacementTest = false;

  // Non-Korean fields
  String? alienCardFrontPath;
  String? alienCardBackPath;
  String? nonKoreanConstructionCertPath;
  String? nonKoreanQualificationCertPath;
  bool nonKoreanHasPrePlacementTest = false;

  Widget buildUploader({required String label, required String? filePath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: Center(
          child: Text(
            filePath == null ? '${label} ${AppLocalizations.of(context)?.uploadLabel ?? '업로드'}' : '${label} ${AppLocalizations.of(context)?.uploadedLabel ?? '업로드 완료'}',
            style: TextStyle(
              color: filePath == null ? Colors.grey : Colors.green,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isKorea = widget.selectedCountry['locale']?.languageCode == 'ko';
    final isChina = widget.selectedCountry['locale']?.languageCode == 'zh';
    final isEnglish = widget.selectedCountry['locale']?.languageCode == 'en';
    final appLoc = AppLocalizations.of(context);

    if (isKorea) {
      // 기존 한국 첨부 서류 UI
      return Scaffold(
        appBar: AppBar(
          title: Text(appLoc?.attachmentTitle ?? '첨부 서류'),
          backgroundColor: const Color(0xFF002B5B),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildUploader(
                label: appLoc?.idCardLabel ?? '신분증',
                filePath: idCardPath,
                onTap: () {},
              ),
              buildUploader(
                label: appLoc?.constructionCertLabel ?? '건설이수증',
                filePath: constructionCertPath,
                onTap: () {},
              ),
              buildUploader(
                label: appLoc?.qualificationCertLabel ?? '관련 자격증',
                filePath: qualificationCertPath,
                onTap: () {},
              ),
              Row(
                children: [
                  Switch(
                    value: hasPrePlacementTest,
                    onChanged: (val) {
                      setState(() {
                        hasPrePlacementTest = val;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(appLoc?.prePlacementTestLabel ?? '배치전검사 결과 있음'),
                ],
              ),
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignUpCompleteScreen()),
                    (route) => false,
                  );
                },
                child: Text(appLoc?.signUpButton ?? '가입', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    } else if (isChina || isEnglish) {
      // 중국/영어권 첨부 서류 UI
      return Scaffold(
        appBar: AppBar(
          title: Text(appLoc?.attachmentTitle ?? 'Attachment Documents'),
          backgroundColor: const Color(0xFF002B5B),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildUploader(
                label: appLoc?.alienCardFrontLabel ?? '외국인 등록증 앞면',
                filePath: alienCardFrontPath,
                onTap: () {},
              ),
              buildUploader(
                label: appLoc?.alienCardBackLabel ?? '외국인 등록증 뒷면',
                filePath: alienCardBackPath,
                onTap: () {},
              ),
              buildUploader(
                label: appLoc?.constructionCertLabel ?? '건설이수증',
                filePath: nonKoreanConstructionCertPath,
                onTap: () {},
              ),
              buildUploader(
                label: appLoc?.qualificationCertLabel ?? '건설 관련 자격증',
                filePath: nonKoreanQualificationCertPath,
                onTap: () {},
              ),
              Row(
                children: [
                  Switch(
                    value: nonKoreanHasPrePlacementTest,
                    onChanged: (val) {
                      setState(() {
                        nonKoreanHasPrePlacementTest = val;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(appLoc?.prePlacementTestLabel ?? '배치전검사 결과 있음'),
                ],
              ),
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignUpCompleteScreen()),
                    (route) => false,
                  );
                },
                child: Text(appLoc?.signUpButton ?? 'Sign Up', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(appLoc?.attachmentTitle ?? '첨부 서류')),
        body: Center(child: Text(appLoc?.unsupportedCountryLabel ?? '지원하지 않는 국가입니다.')),
      );
    }
  }
}

class SignUpCompleteScreen extends StatelessWidget {
  const SignUpCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'Welcome! 🤗',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
} 