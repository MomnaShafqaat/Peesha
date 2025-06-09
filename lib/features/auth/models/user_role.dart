enum UserRole { admin, employer, employee }

String roleToString(UserRole role) {
  return role.toString().split('.').last;
}

UserRole stringToRole(String role) {
  return UserRole.values.firstWhere((e) => e.name == role);
}
