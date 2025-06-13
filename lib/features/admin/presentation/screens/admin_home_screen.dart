/*import 'package:flutter/material.dart';
import 'package:peesha/services/auth_service.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/role-selection',
                      (route) => false
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome Admin!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peesha/services/auth_service.dart';
import 'package:peesha/features/employer/data/job_model.dart';
import 'package:peesha/features/employee/data/employee_model.dart';
import 'package:peesha/features/employer/data/employer_model.dart';
import 'package:peesha/services/auth_service.dart';
import 'job_post_screen.dart';



class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await AuthService().signOut(); // your custom service
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/role-selection',
                        (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllEmployeesScreen()),
                );

                // TODO: Navigate to total employees screen or show count

              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('View Total Employees'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployersPage()),
                );

                // TODO: Navigate to total employers screen or show count

              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('View Total Employers'),
            ),



            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JobPostScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('View Jobs'),
            ),
          ],
        ),
      ),
    );
  }
}


// ------------------------ All Employees Screen ------------------------

class AllEmployeesScreen extends StatefulWidget {
  const AllEmployeesScreen({Key? key}) : super(key: key);

  @override
  State<AllEmployeesScreen> createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends State<AllEmployeesScreen> {
  late Future<List<Employee>> _employeeListFuture;

  @override
  void initState() {
    super.initState();
    _employeeListFuture = fetchEmployees();
  }

  Future<List<Employee>> fetchEmployees() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Employee.fromJson({
        ...data,
        'id': doc.id,
        'fullName': data['fullName'] ?? data['name'] ?? '',
        'educationList': [],
        'experienceList': [],
        'certificateList': [],
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Employees'),
      ),
      body: FutureBuilder<List<Employee>>(
        future: _employeeListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final employees = snapshot.data;

          if (employees == null || employees.isEmpty) {
            return const Center(child: Text('No employees found.'));
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: employee.profileImageUrl.isNotEmpty
                        ? NetworkImage(employee.profileImageUrl)
                        : null,
                    child: employee.profileImageUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(employee.fullName),
                  subtitle: Text(employee.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // TODO: Navigate to detailed profile page
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EmployersPage extends StatefulWidget {
  const EmployersPage({Key? key}) : super(key: key);

  @override
  State<EmployersPage> createState() => _EmployersPageState();
}

class _EmployersPageState extends State<EmployersPage> {
  late Future<List<Employer>> _employerList;

  @override
  void initState() {
    super.initState();
    _employerList = fetchEmployersWithProfiles();
  }
  Future<List<Employer>> fetchEmployersWithProfiles() async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'employer')
        .get();

    final List<Employer> employers = [];

    for (var userDoc in usersSnapshot.docs) {
      final data = userDoc.data() as Map<String, dynamic>;
      final uid = data['uid'] ?? userDoc.id;

      final profileSnapshot = await FirebaseFirestore.instance
          .collection('employerProfiles')
          .doc(uid)
          .get();

      if (profileSnapshot.exists) {
        final profileData = profileSnapshot.data()!;
        employers.add(Employer.fromJson(profileData));
      } else {
        print('⚠ No employer profile found for UID: $uid');
      }
    }

    return employers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employers')),
      body: FutureBuilder<List<Employer>>(
        future: _employerList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          if (snapshot.hasError) {
            print('Employer fetch error: ${snapshot.error}');
            return Center(child: Text('Error fetching employers: ${snapshot.error}'));
          }

          final employers = snapshot.data;

          if (employers == null || employers.isEmpty) {
            return const Center(child: Text('No employers found.'));
          }

          return ListView.builder(
            itemCount: employers.length,
            itemBuilder: (context, index) {
              final emp = employers[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(emp.companyName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Industry: ${emp.industry}'),
                      Text('Type: ${emp.companyType}'),
                      Text('Email: ${emp.contactEmail}'),
                      Text('Phone: ${emp.contactPhone}'),
                      Text('Location: ${emp.city}, ${emp.state}, ${emp.country}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ------------------------ Job Post Screen ------------------------
class JobPostScreen extends StatelessWidget {
  const JobPostScreen({super.key});

  Future<void> deleteJob(String jobId) async {
    try {
      await FirebaseFirestore.instance.collection('Job').doc(jobId).delete();
    } catch (e) {
      debugPrint('Failed to delete job: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posted Jobs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Job').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No jobs found.'));
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final doc = jobs[index];
              final job = Job.fromJson(doc.data() as Map<String, dynamic>, doc.id);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(job.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${job.location} • ${job.jobType}'),
                      Text('Employer: ${job.employerName}'),
                      Text('Deadline: ${job.dateDeadline}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Job'),
                          content: const Text('Are you sure you want to delete this job?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await deleteJob(job.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}