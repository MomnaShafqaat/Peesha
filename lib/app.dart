// import 'package:flutter/material.dart';
// import 'package:peesha/features/employer/presentation/screens/employer_home_screen.dart';
// import 'package:peesha/features/auth/presentation/screens/login_page.dart';
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Peesha Employer',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           elevation: 0,
//           centerTitle: true,
//           backgroundColor: Colors.blue,
//           titleTextStyle: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Colors.blue),
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 12,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.blue, width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       home: const LoginScreen(), // 👈 Go to login screen first
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'homepage.dart';       // ✅ Home screen
import 'features/auth/presentation/screens/login_page.dart';  // ✅ Make sure this file exists and is correctly imported

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  PeeshaHomepage(),
        '/login': (context) => const LoginScreen(), // 👈 Add this route
      },
    );
  }
}
