import 'package:flutter/material.dart';
import 'admin_service.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List products = [];
  bool loading = true;

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    products = await AdminService().getProducts();
    setState(() => loading = false);
  }

  Future<void> addProduct() async {
    await AdminService().addProduct(
      nameController.text,
      double.parse(priceController.text),
    );

    nameController.clear();
    priceController.clear();

    fetchProducts();
  }

  Future<void> deleteProduct(String id) async {
    await AdminService().deleteProduct(id);
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Products")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Add Product Form
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Price",
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addProduct,
                  child: const Text("Add Product"),
                ),
              ],
            ),
          ),

          const Divider(),

          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];

                return ListTile(
                  title: Text(p['name']),
                  subtitle: Text("Price: ${p['price']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteProduct(p['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
