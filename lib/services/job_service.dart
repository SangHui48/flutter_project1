import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/job.dart';

class JobService {
  static Future<List<Job>> fetchJobs() async {
    // Replace with your actual REST API endpoint
    final response = await http.get(Uri.parse('https://mocki.io/v1/0a1e7e2e-2e7b-4e7e-8e7e-0e7e7e7e7e7e'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }
} 