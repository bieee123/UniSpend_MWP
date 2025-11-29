import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/models/transaction_model.dart';
import '../../state/transaction_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Toggle button untuk memperbaiki bug format yang tidak sesuai
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildFormatTab('Week', CalendarFormat.week),
                _buildFormatTab('2 Weeks', CalendarFormat.twoWeeks),
                _buildFormatTab('Month', CalendarFormat.month),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.rectangle,
              ),
              markersMaxCount: 3, // Show up to 3 dots for multiple transactions
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false, // Menyembunyikan tombol format bawaan karena kita gunakan tombol kustom
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatTab(String title, CalendarFormat format) {
    bool isSelected = _calendarFormat == format;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _calendarFormat = format;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  List<TransactionModel> _getEventsForDay(DateTime day) {
    // This function only gets called by TableCalendar when needed
    // So it should be efficient and not trigger unnecessary rebuilds
    return [];
  }

  Widget _buildTransactionList() {
    final transactionProvider = context.watch<TransactionProvider>();

    return StreamBuilder<List<TransactionModel>>(
      stream: transactionProvider.streamTransactions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allTransactions = snapshot.data ?? [];

        // Filter transactions for the selected day
        final selectedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
        final dailyTransactions = allTransactions
            .where((transaction) =>
                DateTime(transaction.date.year, transaction.date.month, transaction.date.day)
                    .isAtSameMomentAs(selectedDate))
            .toList();

        if (dailyTransactions.isEmpty) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No transactions for this day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap on a date with transactions to view details',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: dailyTransactions.length,
          itemBuilder: (context, index) {
            final transaction = dailyTransactions[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: transaction.type == 'income'
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    transaction.type == 'income'
                        ? Icons.add
                        : Icons.remove,
                    color: transaction.type == 'income' ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(transaction.note),
                subtitle: Text('${transaction.categoryId} • ${transaction.date.hour.toString().padLeft(2, '0')}:${transaction.date.minute.toString().padLeft(2, '0')}'),
                trailing: Text(
                  '${transaction.type == 'income' ? '+' : '-'}Rp ${transaction.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    color: transaction.type == 'income' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}