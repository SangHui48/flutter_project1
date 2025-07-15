import 'package:flutter/material.dart';
import 'auth/country_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  final void Function(Locale) onLocaleSelected;
  
  const SplashScreen({super.key, required this.onLocaleSelected});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => CountrySelectionScreen(onLocaleSelected: widget.onLocaleSelected),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B5B),
      body: Center(
        child: Text(
          'ODDO',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
} 