import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'manager_dashboard.dart';
import 'user_dashboard.dart';

class RoleCheck {
  static void navigateByRole(BuildContext context, String roleInput, String role) {
    if (roleInput == '1' && role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } else if (roleInput == '2' && role == 'manager') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ManagerDashboard()),
      );
    } else if (role == 'user') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access Denied')),
      );
    }
  }
}
