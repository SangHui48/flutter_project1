import 'package:flutter/material.dart';
import 'sign_up_screen.dart';

class CountrySelectionScreen extends StatelessWidget {
  final void Function(Locale) onLocaleSelected;
  
  const CountrySelectionScreen({super.key, required this.onLocaleSelected});

  @override
  Widget build(BuildContext context) {
    final countries = [
      {'label': '한국', 'locale': const Locale('ko'), 'flag': '🇰🇷'},
      {'label': '中国', 'locale': const Locale('zh'), 'flag': '🇨🇳'},
      {'label': 'English', 'locale': const Locale('en'), 'flag': '🇺🇸'},
      {'label': 'Việt Nam', 'locale': const Locale('vi'), 'flag': '🇻🇳'},
    ];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '국가를 선택하세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Color(0xFF002B5B),
              ),
            ),
            const SizedBox(height: 32),
            ...countries.map((country) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002B5B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                ),
                onPressed: () {
                  final locale = country['locale'] as Locale;
                  onLocaleSelected(locale);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      country['flag'] as String,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      country['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
} 