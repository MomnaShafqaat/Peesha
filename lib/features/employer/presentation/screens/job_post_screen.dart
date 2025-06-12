










import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peesha/features/employer/data/job_model.dart';
import 'package:peesha/core/utils/app_constants.dart';
import 'package:peesha/features/employer/presentation/screens/employer_profile_screen.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isProfileComplete = false;
  bool _isLoading = true;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();

  String _jobType = 'Full-time';
  String _experienceLevel = 'Mid-level';
  DateTime _postedDate = DateTime.now();
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  final String _employerId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String _employerName = 'Temp Employer';

  bool _showForm = false;
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fabRotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.75,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _checkEmployerProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _salaryController.clear();
    _jobType = 'Full-time';
    _experienceLevel = 'Mid-level';
    _postedDate = DateTime.now();
    _deadline = DateTime.now().add(const Duration(days: 30));
  }

  Future<void> _selectDate(BuildContext context, bool isDeadline) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _deadline : _postedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xFF90CAF9),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _deadline = picked;
        } else {
          _postedDate = picked;
        }
      });
    }
  }

  Future<void> _submitJob() async {
    if (_formKey.currentState!.validate()) {
      // Show loading animation
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF90CAF9)),
          ),
        ),
      );

      final job = Job(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        salary: _salaryController.text.trim(),
        jobType: _jobType,
        experienceLevel: _experienceLevel,
        employerId: _employerId,
        employerName: _employerName,
        datePosted: DateFormat('yyyy-MM-dd').format(_postedDate),
        dateDeadline: DateFormat('yyyy-MM-dd').format(_deadline),
      );

      try {
        await FirebaseFirestore.instance.collection('Job').add(job.toJson());
        Navigator.pop(context); // Close loading dialog

        if (mounted) {
          _showSuccessSnackBar();
          setState(() {
            _showForm = false;
            _clearForm();
          });
          _fabAnimationController.reverse();
        }
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        _showErrorSnackBar(e.toString());
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Job posted successfully!', style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: const Color(0xFF4FC3F7), // Light blue success color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Error: $error', style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: const Color(0xFFE57373), // Light red for errors
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _checkEmployerProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('employerProfiles').doc(uid).get();
    final profile = doc.data();

    setState(() {
      _isProfileComplete = doc.exists;
      _employerName = profile?['companyName'] ?? 'Temp Employer';
      _isLoading = false;
    });

    if (_isProfileComplete) {
      _animationController.forward();
    }
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildStyledDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM dd, yyyy').format(date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobForm() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FAFF),
            Color(0xFFF0F4FF),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF90CAF9).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.work_outline, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Create New Job Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildStyledTextField(
                controller: _titleController,
                label: 'Job Title',
                icon: Icons.work,
                validator: (value) => value == null || value.isEmpty ? 'Job title is required' : null,
              ),

              _buildStyledTextField(
                controller: _descriptionController,
                label: 'Job Description',
                icon: Icons.description,
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Job description is required' : null,
              ),

              _buildStyledTextField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on,
              ),

              _buildStyledTextField(
                controller: _salaryController,
                label: 'Salary',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),

              _buildStyledDropdown(
                value: _jobType,
                label: 'Job Type',
                icon: Icons.business_center,
                items: AppConstants.jobTypes,
                onChanged: (val) => setState(() => _jobType = val!),
              ),

              _buildStyledDropdown(
                value: _experienceLevel,
                label: 'Experience Level',
                icon: Icons.trending_up,
                items: AppConstants.experienceLevels,
                onChanged: (val) => setState(() => _experienceLevel = val!),
              ),

              _buildDateSelector(
                label: 'Posted Date',
                date: _postedDate,
                icon: Icons.today,
                onTap: () => _selectDate(context, false),
              ),

              _buildDateSelector(
                label: 'Application Deadline',
                date: _deadline,
                icon: Icons.event,
                onTap: () => _selectDate(context, true),
              ),

              const SizedBox(height: 12),

              // Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF90CAF9).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _submitJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.publish, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Post Job',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(Job job, String docId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.work, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${job.location} • ${job.jobType}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (job.salary.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD), // Light blue background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF90CAF9)),
                ),
                child: Text(
                  job.salary,
                  style: const TextStyle(
                    color: Color(0xFF1976D2), // Darker blue text
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD), // Light blue background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF90CAF9)),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _titleController.text = job.title;
                          _descriptionController.text = job.description;
                          _locationController.text = job.location;
                          _salaryController.text = job.salary;
                          _jobType = job.jobType;
                          _experienceLevel = job.experienceLevel;
                          _postedDate = DateFormat('yyyy-MM-dd').parse(job.datePosted);
                          _deadline = DateFormat('yyyy-MM-dd').parse(job.dateDeadline);
                          _showForm = true;
                        });
                        _fabAnimationController.forward();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Color(0xFF1976D2), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Edit',
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE), // Light red background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE57373)),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Delete Job Post'),
                            content: const Text('Are you sure you want to delete this job posting? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE57373),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await FirebaseFirestore.instance.collection('Job').doc(docId).delete();
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Color(0xFFD32F2F), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8FAFF),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Job')
            .where('employerId', isEqualTo: _employerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF90CAF9)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.work_off, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No jobs posted yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to create your first job posting',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final doc = jobs[index];
              final job = Job.fromJson(doc.data() as Map<String, dynamic>, doc.id);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    index * 0.1,
                    1.0,
                    curve: Curves.easeOutBack,
                  ),
                )),
                child: _buildJobCard(job, doc.id),
              );
            },
          );
        },
      ),
    );
  }
/*
  Widget _buildProfilePrompt() {
    return Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
        Color(0xFFF8FAFF),
    Color(0xFFF0F4FF),
    ],
    ),
    ),
    child: Center(
    child: Padding(
    padding: const EdgeInsets.all(32.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)], // Changed to light blue theme
    ),
    shape: BoxShape.circle,
    boxShadow: [
    BoxShadow(
    color: const Color(0xFF90CAF9).withOpacity(0.3),
    blurRadius: 20,
    offset: const Offset(0, 8),
    ),
    ],
    ),
    child: const Icon(Icons.business, size: 48, color: Colors.white),
    ),
    const SizedBox(height: 24),
    const Text(
    "Complete Your Profile",
    style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    ),
    ),
    const SizedBox(height: 12),
    Text(
    "Set up your company profile to start posting amazing job opportunities",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 16,
    color: Colors.grey.shade600,
    height: 1.5,
    ),
    ),
    const SizedBox(height: 32),
    Container(
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(
    color: const Color(0xFF90CAF9).withOpacity(0.4),
    blurRadius: 16,
    offset: const Offset(0, 6),
    ),
    ],
    ),
    child: ElevatedButton.icon(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const EmployerProfileScreen()),
    );
    },
    icon: const Icon(Icons.arrow_forward, color: Colors.white),
    label: const Text(
    "Setup Profile Now",
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    ),
    ),
    ),


*/



  Widget _buildProfilePrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "You need to complete your company profile before posting jobs.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployerProfileScreen()),
                );
              },
              icon: const Icon(Icons.business),
              label: const Text("Setup Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Posted Jobs')),
      floatingActionButton: _isProfileComplete
          ? FloatingActionButton(
        child: Icon(_showForm ? Icons.close : Icons.add),
        onPressed: () {
          setState(() {
            _showForm = !_showForm;
            if (!_showForm) _clearForm();
          });
        },
      )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isProfileComplete
          ? (_showForm ? _buildJobForm() : _buildJobList())
          : _buildProfilePrompt(),
    );
  }
}
