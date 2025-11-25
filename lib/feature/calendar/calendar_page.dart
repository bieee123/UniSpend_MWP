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
  Map<DateTime, List<TransactionModel>> _events = {};

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
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
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
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
    // This will be updated with actual transaction data
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Widget _buildTransactionList() {
    final transactionProvider = context.watch<TransactionProvider>();
    
    return StreamBuilder<List<TransactionModel>>(
      stream: transactionProvider.streamTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

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

        // Update the events map for calendar markers
        setState(() {
          _events = _groupTransactionsByDate(allTransactions);
        });

        if (dailyTransactions.isEmpty) {
          return const Center(
            child: Text(
              'No transactions for this day',
              style: TextStyle(fontSize: 18),
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

  Map<DateTime, List<TransactionModel>> _groupTransactionsByDate(List<TransactionModel> transactions) {
    final Map<DateTime, List<TransactionModel>> grouped = {};
    
    for (final transaction in transactions) {
      final date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]?.add(transaction);
    }
    
    return grouped;
  }
}