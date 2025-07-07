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