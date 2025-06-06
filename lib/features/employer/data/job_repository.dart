import 'package:http/http.dart' as http;
import 'dart:convert';
import 'job_model.dart';

class JobRepository {

  Future<Job> postJob(Job job) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(job.toJson()),
    );

    if (response.statusCode == 201) {
      return Job.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post job: ${response.statusCode}');
    }
  }


  final String baseUrl = 'http://your-node-server.com/api'; // Replace with your actual backend URL

  // Post a new job
  Future<Job> createJob(Job job) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(job.toJson()),
    );

    if (response.statusCode == 201) {
      return Job.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create job. Status code: ${response.statusCode}');
    }
  }

  // Get all jobs posted by an employer
  Future<List<Job>> getJobsByEmployer(String employerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs?employerId=$employerId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jobsJson = json.decode(response.body);
      return jobsJson.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs. Status code: ${response.statusCode}');
    }
  }

  // Update an existing job
  Future<Job> updateJob(Job job) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jobs/${job.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(job.toJson()),
    );

    if (response.statusCode == 200) {
      return Job.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update job. Status code: ${response.statusCode}');
    }
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/jobs/$jobId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete job. Status code: ${response.statusCode}');
    }
  }

  // Get all available jobs (for employees to browse)
  Future<List<Job>> getAllJobs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jobsJson = json.decode(response.body);
      return jobsJson.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all jobs. Status code: ${response.statusCode}');
    }
  }
}
