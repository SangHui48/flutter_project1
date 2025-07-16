import 'package:flutter/material.dart';
import 'sign_up_screen.dart';

class CountrySelectionScreen extends StatefulWidget {
  final void Function(Locale) onLocaleSelected;
  
  const CountrySelectionScreen({super.key, required this.onLocaleSelected});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  final List<Map<String, dynamic>> countries = [
    {'label': '한국', 'locale': const Locale('ko'), 'flag': '🇰🇷'},
    {'label': '中国', 'locale': const Locale('zh'), 'flag': '🇨🇳'},
    {'label': 'English', 'locale': const Locale('en'), 'flag': null},
  ];

  Map<String, dynamic>? selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = countries[0];
  }

  @override
  Widget build(BuildContext context) {
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
            DropdownButton<Map<String, dynamic>>(
              value: selectedCountry,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF002B5B)),
              items: countries.map((country) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: country,
                  child: Row(
                    children: [
                      if (country['flag'] != null)
                        Text(country['flag'] as String, style: const TextStyle(fontSize: 22))
                      else
                        const Icon(Icons.public, size: 22, color: Color(0xFF002B5B)),
                      const SizedBox(width: 12),
                      Text(
                        country['label'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002B5B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
              ),
              onPressed: selectedCountry == null
                  ? null
                  : () {
                      final locale = selectedCountry!['locale'] as Locale;
                      widget.onLocaleSelected(locale);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SignUpScreen(selectedCountry: selectedCountry!),
                        ),
                      );
                    },
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 