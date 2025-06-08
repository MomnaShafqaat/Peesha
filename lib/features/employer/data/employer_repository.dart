import 'package:peesha/features/employer/data/employer_model.dart';
import 'package:peesha/features/employer/data/job_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployerRepository {
  final String baseUrl = 'http://your-node-server.com/api';

  Future<Employer> createEmployer(Employer employer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employer.toJson()),
    );

    if (response.statusCode == 201) {
      return Employer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create employer profile');
    }
  }

  Future<Employer> getEmployer(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/employers/$id'));

    if (response.statusCode == 200) {
      return Employer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load employer profile');
    }
  }

  Future<Employer> updateEmployer(String id, Employer employer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/employers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employer.toJson()),
    );

    if (response.statusCode == 200) {
      return Employer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update employer profile');
    }
  }

  Future<Job> postJob(Job job) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(job.toJson()),
    );

    if (response.statusCode == 201) {
      return Job.fromRestApi(json.decode(response.body));
    } else {
      throw Exception('Failed to post job: ${response.statusCode}');
    }
  }

  Future<List<Job>> getPostedJobs(String employerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs?employerId=$employerId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Job.fromRestApi(json)).toList();
    } else {
      throw Exception('Failed to load jobs: ${response.statusCode}');
    }
  }

  Future<void> deleteJob(String jobId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/jobs/$jobId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete job: ${response.statusCode}');
    }
  }
}

