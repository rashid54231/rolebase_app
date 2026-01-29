import 'package:flutter/material.dart';
import 'admin_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => loading = true);
    users = await AdminService().getUsers();
    setState(() => loading = false);
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    if (id.isEmpty) return;
    await AdminService().deleteUser(id);
    fetchUsers();
  }

  // Edit user (name & role)
  Future<void> editUser(String id, String currentName, String currentRole) async {
    final nameController = TextEditingController(text: currentName);
    final roleController = TextEditingController(text: currentRole);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: "Role"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final newRole = roleController.text.trim();

              if (newName.isNotEmpty && newRole.isNotEmpty) {
                await AdminService().updateUser(id, newName, newRole);
                fetchUsers();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final userId = user['id']?.toString() ?? '';
          final userName = user['name'] ?? '';
          final userRole = user['role'] ?? 'user';

          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(userName),
              subtitle: Text("Role: $userRole"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit button
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => editUser(userId, userName, userRole),
                  ),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(userId),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
