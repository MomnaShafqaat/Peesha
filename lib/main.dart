//import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'app.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
//   ErrorWidget.builder = (FlutterErrorDetails details) {
//     return Center(child: Text('Something went wrong:\n${details.exception}', textAlign: TextAlign.center));
//   };
//
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await MobileAds.instance.initialize(); // ✅ Initialize Google Ads

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
