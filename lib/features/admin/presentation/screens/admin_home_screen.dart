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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text('Logout', style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await AuthService().signOut();
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Admin!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            OutlinedButton.icon(
              icon: const Icon(Icons.people, color: Colors.white),
              label: const Text(
                'View Total Employees',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllEmployeesScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              icon: const Icon(Icons.apartment, color: Colors.white),
              label: const Text(
                'View Total Employers',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployersPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              icon: const Icon(Icons.work, color: Colors.white),
              label: const Text(
                'View Jobs',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JobPostScreen()),
                );
              },
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'All Employees',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Employee>>(
        future: _employeeListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final employees = snapshot.data;

          if (employees == null || employees.isEmpty) {
            return const Center(
              child: Text(
                'No employees found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Total Employees: ${employees.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[800],
                          backgroundImage:
                          employee.profileImageUrl.isNotEmpty
                              ? NetworkImage(employee.profileImageUrl)
                              : null,
                          child: employee.profileImageUrl.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        title: Text(
                          employee.fullName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          employee.email,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Employers',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Employer>>(
        future: _employerList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            print('Employer fetch error: ${snapshot.error}');
            return Center(
              child: Text(
                'Error fetching employers: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final employers = snapshot.data;

          if (employers == null || employers.isEmpty) {
            return const Center(
              child: Text(
                'No employers found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Employers: ${employers.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: employers.length,
                  itemBuilder: (context, index) {
                    final emp = employers[index];
                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          emp.companyName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Industry: ${emp.industry}',
                                style: TextStyle(color: Colors.grey[300])),
                            Text('Type: ${emp.companyType}',
                                style: TextStyle(color: Colors.grey[300])),
                            Text('Email: ${emp.contactEmail}',
                                style: TextStyle(color: Colors.grey[300])),
                            Text('Phone: ${emp.contactPhone}',
                                style: TextStyle(color: Colors.grey[300])),
                            Text(
                                'Location: ${emp.city}, ${emp.state}, ${emp.country}',
                                style: TextStyle(color: Colors.grey[300])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'All Posted Jobs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Job').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No jobs found.', style: TextStyle(color: Colors.white)),
            );
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final doc = jobs[index];
              final job = Job.fromJson(doc.data() as Map<String, dynamic>, doc.id);

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    job.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${job.location} • ${job.jobType}',
                            style: TextStyle(color: Colors.grey[300])),
                        Text('Employer: ${job.employerName}',
                            style: TextStyle(color: Colors.grey[300])),
                        Text('Deadline: ${job.dateDeadline}',
                            style: TextStyle(color: Colors.grey[300])),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.grey[850],
                          title: const Text('Delete Job', style: TextStyle(color: Colors.white)),
                          content: const Text(
                            'Are you sure you want to delete this job?',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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
