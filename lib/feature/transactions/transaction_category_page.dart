import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionCategoryPage extends StatelessWidget {
  const TransactionCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Transaction Type"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.wallet,
                    size: 60,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "What type of transaction?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Choose the type of transaction you'd like to add",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "EXPENSES",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            _buildCategoryCard(
              context: context,
              title: "Food & Drink",
              icon: Icons.local_cafe,
              iconColor: Colors.orange,
              category: "Food & Drink",
              type: "expense",
            ),
            const SizedBox(height: 10),
            _buildCategoryCard(
              context: context,
              title: "Transport",
              icon: Icons.directions_car,
              iconColor: Colors.blue,
              category: "Transport",
              type: "expense",
            ),
            const SizedBox(height: 10),
            _buildCategoryCard(
              context: context,
              title: "Shopping",
              icon: Icons.shopping_bag,
              iconColor: Colors.purple,
              category: "Shopping",
              type: "expense",
            ),
            const SizedBox(height: 10),
            _buildCategoryCard(
              context: context,
              title: "Others",
              icon: Icons.category,
              iconColor: Colors.grey,
              category: "Others",
              type: "expense",
            ),
            const SizedBox(height: 20),
            const Text(
              "INCOME",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            _buildCategoryCard(
              context: context,
              title: "Salary",
              icon: Icons.work,
              iconColor: Colors.green,
              category: "Salary",
              type: "income",
            ),
            const SizedBox(height: 10),
            _buildCategoryCard(
              context: context,
              title: "Extra Income",
              icon: Icons.attach_money,
              iconColor: Colors.teal,
              category: "Extra Income",
              type: "income",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required String category,
    required String type,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigasi ke halaman add transaction dengan informasi kategori dan tipe
          context.push('/transactions/add-with-category', extra: {
            'category': category,
            'type': type,
          });
        },
      ),
    );
  }
}