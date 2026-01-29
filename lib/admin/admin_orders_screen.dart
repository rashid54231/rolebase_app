import 'package:flutter/material.dart';
import 'admin_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => loading = true);
    orders = await AdminService().getOrders();
    setState(() => loading = false);
  }

  Future<void> updateStatus(String id, String status) async {
    if (id.isEmpty) return; // Prevent crash if ID invalid
    await AdminService().updateOrderStatus(id, status);
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Orders")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          // Safely convert ID and status to String
          final orderId = order['id']?.toString() ?? '';
          final orderStatus = order['status']?.toString() ?? 'pending';

          return Card(
            child: ListTile(
              title: Text("Order ID: $orderId"),
              subtitle: Text("Status: $orderStatus"),
              trailing: DropdownButton<String>(
                value: orderStatus,
                items: const [
                  DropdownMenuItem(
                    value: "pending",
                    child: Text("Pending"),
                  ),
                  DropdownMenuItem(
                    value: "approved",
                    child: Text("Approved"),
                  ),
                  DropdownMenuItem(
                    value: "delivered",
                    child: Text("Delivered"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) updateStatus(orderId, value);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
