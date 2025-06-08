import 'package:http/http.dart' as http;
import 'dart:convert';
import 'job_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'job_model.dart';

class JobRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'Jobs';

  // Create a job
  Future<void> createJob(Job job) async {
    await _firestore.collection(collectionPath).add(job.toJson());
  }

  // Get all jobs (for home page)
  Future<List<Job>> getAllJobs() async {
    final snapshot = await _firestore.collection(collectionPath).get();
    return snapshot.docs
        .map((doc) => Job.fromJson(doc.data(), doc.id))
        .toList();
  }

  // Get jobs by employerId (filtered)
  Future<List<Job>> getJobsByEmployer(String employerId) async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .where('employerId', isEqualTo: employerId)
        .get();

    return snapshot.docs
        .map((doc) => Job.fromJson(doc.data(), doc.id))
        .toList();
  }
}
