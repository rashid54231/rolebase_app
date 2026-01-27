import 'package:flutter/material.dart';
import 'supabase.dart';
import 'admin/admin_dashboard.dart';
import 'manager/manager_dashboard.dart';
import 'user/user_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // 1️⃣ LOGIN (email + password)
      final authRes = await SupabaseConfig.client.auth
          .signInWithPassword(email: email, password: password);

      final user = authRes.user;
      if (user == null) {
        throw 'Invalid email or password';
      }

      // 2️⃣ GET ROLE from users table
      final roleRes = await SupabaseConfig.client
          .from('users')
          .select('role')
          .eq('id', user.id);

      if (roleRes.isEmpty) {
        throw 'Role not assigned. Contact admin.';
      }

      final role = roleRes[0]['role'];

      // 3️⃣ OPEN DASHBOARD
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else if (role == 'manager') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ManagerDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
