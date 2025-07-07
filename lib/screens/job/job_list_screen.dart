import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../models/job.dart';
import '../../services/job_service.dart';
import '../../l10n/app_localizations.dart';

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
    jobsFuture = JobService.fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: AppLocalizations.of(context)!.jobListTitle,
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
                        color: Colors.black.withValues(alpha: 0.05),
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
                            const Icon(Icons.location_on, color: Color(0xFF002B5B), size: 18),
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