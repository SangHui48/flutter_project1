import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linklab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF002B5B)),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: SplashScreen(onLocaleSelected: setLocale),
    );
  }
}

class Job {
  final String title;
  final String location;
  final String wage;

  Job({required this.title, required this.location, required this.wage});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      wage: json['wage'] ?? '',
    );
  }
}

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late Future<List<Job>> jobsFuture;

  @override
  void initState() {
    super.initState();
    jobsFuture = fetchJobs();
  }

  Future<List<Job>> fetchJobs() async {
    // Replace with your actual REST API endpoint
    final response = await http.get(Uri.parse('https://mocki.io/v1/0a1e7e2e-2e7b-4e7e-8e7e-0e7e7e7e7e7e'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B5B),
        title: Text(AppLocalizations.of(context)!.jobListTitle, style: const TextStyle(color: Colors.white)),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Job>>(
          future: jobsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.loadingJobs),
                ],
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text(AppLocalizations.of(context)!.failedToLoadJobs));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noJobsAvailable));
            }
            final jobs = snapshot.data!;
            return ListView.separated(
              itemCount: jobs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Color(0xFF002B5B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Color(0xFF002B5B), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              job.location,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          job.wage,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF002B5B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.applyButton,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CountrySelectionScreen(onLocaleSelected: widget.onLocaleSelected),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B5B),
      body: Center(
        child: Text(
          'Linklab',
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

// AppBar for screens after splash
AppBar buildAppBar(BuildContext context, {bool showBack = false}) {
  return AppBar(
    backgroundColor: const Color(0xFF002B5B),
    leading: showBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 26),
            onPressed: () => Navigator.of(context).maybePop(),
          )
        : null,
    title: Text(
      AppLocalizations.of(context)?.appTitle ?? 'Linklab',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        fontFamily: 'Roboto',
        letterSpacing: 2.5,
      ),
    ),
    centerTitle: true,
    elevation: 2,
  );
}

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
      appBar: buildAppBar(context, showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '국가를 선택하세요',
              textAlign: TextAlign.center,
              style: const TextStyle(
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

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context, showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.idLabel ?? 'ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.passwordLabel ?? 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002B5B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)?.signUpButton ?? 'Sign Up',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF002B5B),
                side: const BorderSide(color: Color(0xFF002B5B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)?.loginButton ?? 'Login',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Social login (coming soon)',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.more_horiz, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
