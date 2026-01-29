import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  // Use Supabase.instance.client directly
  final supabase = Supabase.instance.client;

  // ✅ Get all users
  Future<List> getUsers() async {
    final res = await supabase.from("users").select();
    return res;
  }

  // ✅ Get all products
  Future<List> getProducts() async {
    final res = await supabase.from("products").select();
    return res;
  }

  // ✅ Add product
  Future<void> addProduct(String name, double price) async {
    await supabase.from("products").insert({
      "name": name,
      "price": price,
    });
  }

  // ✅ Delete product
  Future<void> deleteProduct(String id) async {
    if (id.isEmpty) return; // Prevent invalid UUID
    await supabase.from("products").delete().eq("id", id);
  }

  // ✅ Get all orders
  Future<List> getOrders() async {
    final res = await supabase.from("orders").select();
    return res;
  }

  // ✅ Update order status
  Future<void> updateOrderStatus(String id, String status) async {
    if (id.isEmpty) return; // Prevent invalid UUID
    await supabase.from("orders").update({"status": status}).eq("id", id);
  }
}
