import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trx = ModalRoute.of(context)!.settings.arguments as TransactionModel;

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Detail")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Amount: Rp ${trx.amount}"),
            const SizedBox(height: 8),
            Text("Category: ${trx.categoryId}"),
            const SizedBox(height: 8),
            Text("Type: ${trx.type}"),
            const SizedBox(height: 8),
            Text("Note: ${trx.note}"),
            const SizedBox(height: 8),
            Text("Date: ${trx.date.toString().split(" ")[0]}"),
          ],
        ),
      ),
    );
  }
}
