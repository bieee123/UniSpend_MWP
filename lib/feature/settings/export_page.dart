import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../state/transaction_provider.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: const Text(
                "Export Data",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Select Date Range",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text("Start Date"),
                            subtitle: Text(_startDate.toString().split(' ')[0]),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: _selectStartDate,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text("End Date"),
                            subtitle: Text(_endDate.toString().split(' ')[0]),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: _selectEndDate,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Export Options",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isExporting
                          ? null
                          : () => _exportPDF(transactionProvider),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Export as PDF"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _isExporting
                          ? null
                          : () => _exportCSV(transactionProvider),
                      icon: const Icon(Icons.table_chart),
                      label: const Text("Export as CSV"),
                    ),
                  ],
                ),
              ),
            ),
            if (_isExporting)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: _endDate,
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _exportPDF(TransactionProvider provider) async {
    setState(() {
      _isExporting = true;
    });

    try {
      // Get all transactions in the date range
      final transactions = (await provider.streamTransactions().first)
          .where((t) =>
              t.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(_endDate.add(const Duration(days: 1))))
          .toList();

      // Create PDF document
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  'UniSpend Transaction Report',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Text(
                        'User: ${FirebaseAuth.instance.currentUser?.email ?? "N/A"}'),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Text(
                        'Date Range: ${_startDate.toString().split(' ')[0]} to ${_endDate.toString().split(' ')[0]}'),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: null,
                  children: [
                    // Header row
                    pw.TableRow(
                      children: [
                        pw.Text('Date',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Category',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Type',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Amount',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Note',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    // Data rows
                    ...transactions.map((t) => pw.TableRow(
                          children: [
                            pw.Text(t.date.toString().split(' ')[0]),
                            pw.Text(t.categoryId),
                            pw.Text(t.type),
                            pw.Text(
                                'Rp ${t.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                            pw.Text(t.note),
                          ],
                        )),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        'Total Income: Rp ${transactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount).round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                    pw.Text(
                        'Total Expense: Rp ${transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount).round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Save PDF to device
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/transactions_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF exported successfully to ${file.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting PDF: $e')),
        );
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  Future<void> _exportCSV(TransactionProvider provider) async {
    setState(() {
      _isExporting = true;
    });

    try {
      // Get all transactions in the date range
      final transactions = (await provider.streamTransactions().first)
          .where((t) =>
              t.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(_endDate.add(const Duration(days: 1))))
          .toList();

      // Prepare CSV data
      List<List<String>> csvData = [
        ['date', 'category', 'type', 'amount', 'note']
      ];

      for (final transaction in transactions) {
        csvData.add([
          transaction.date.toString().split(' ')[0],
          transaction.categoryId,
          transaction.type,
          transaction.amount.toString(),
          transaction.note,
        ]);
      }

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(csvData);

      // Save CSV to device
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/transactions_export_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV exported successfully to ${file.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting CSV: $e')),
        );
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }
}
