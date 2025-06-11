import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:peesha/features/auth/models/user_role.dart';


// Import your theme colors
class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGray = Color(0xFF1F2937);
  static const Color mediumGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFFF3F4F6);
  static const Color surface = Color(0xFFFAFAFA);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGray,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.mediumGray,
    height: 1.5,
  );
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? selectedRole;

  // Role data with icons and descriptions
  final List<RoleOption> roleOptions = [
    RoleOption(
      role: UserRole.employee,
      title: 'Job Seeker',
      description: 'Find your dream job and build your career',
      icon: Icons.person_search,
    ),
    RoleOption(
      role: UserRole.employer,
      title: 'Employer',
      description: 'Post jobs and find the best talent',
      icon: Icons.business_center,
    ),
    RoleOption(
      role: UserRole.admin,
      title: 'Administrator',
      description: 'Manage platform and oversee operations',
      icon: Icons.admin_panel_settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Choose Your Role',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome to Peesha',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select your role to get started with the right experience',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Role Selection Cards
              Expanded(
                child: ListView.separated(
                  itemCount: roleOptions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final option = roleOptions[index];
                    final isSelected = selectedRole == option.role;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = option.role;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.lightGray,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.black.withOpacity(0.05),
                              blurRadius: isSelected ? 12 : 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.lightGray,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                option.icon,
                                size: 24,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.mediumGray,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option.description,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedRole != null
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignupScreen(role: selectedRole!),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColors.lightGray,
                  ),
                  child: Text(
                    selectedRole != null ? 'Continue as ${_getRoleTitle(selectedRole!)}' : 'Select a Role',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.employee:
        return 'Job Seeker';
      case UserRole.employer:
        return 'Employer';
      case UserRole.admin:
        return 'Administrator';
    }
  }
}

class RoleOption {
  final UserRole role;
  final String title;
  final String description;
  final IconData icon;

  RoleOption({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
  });
}