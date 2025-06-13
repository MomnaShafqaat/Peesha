import 'package:flutter/material.dart';
import 'employee_profile_setup.dart';
import 'employee_home_screen.dart';
import 'employee_my_jobs_screen.dart'; // ✅ Import the new screen
import 'employee_messages_screen.dart';
import 'employee_profile_screen.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    EmployeeHomeScreen(),
    MyJobsScreen(), // ✅ New screen
    EmployeeMessagesScreen(),
    EmployeeProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Employee'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'My Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),// ✅ Added
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}