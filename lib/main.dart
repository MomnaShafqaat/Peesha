import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add this
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://qcncxcwoimlrhskdkgrs.supabase.co', // 🔁 Replace this
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjbmN4Y3dvaW1scmhza2RrZ3JzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3MzAzMzksImV4cCI6MjA2NTMwNjMzOX0.1vgelUXMwwe13fCIPgULKPUeAUqwe4PxqAhTfZct4LM',                   // 🔁 Replace this
  );

  // Custom error widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        'Something went wrong:\n${details.exception}',
        textAlign: TextAlign.center,
      ),
    );
  };

  runApp(const MyApp());
}
