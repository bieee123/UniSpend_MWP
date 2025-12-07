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
          // Toggle button with modern styling
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green background
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF0A7F66).withOpacity(0.3), // Subtle Emerald Deep Green border
                width: 1,
              ),
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
                color: Color(0xFF0A7F66), // Emerald Deep Green
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF0A7F66).withOpacity(0.2), // Light Emerald Deep Green
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              markersMaxCount: 4, // Show up to 4 dots for multiple transactions
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
            color: isSelected ? null : Colors.grey[200], // Keep unselected grey
            gradient: isSelected
              ? const LinearGradient(
                  colors: [Colors.green, Colors.teal], // Match transaction page gradient
                )
              : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700], // White text for selected
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

  // Store transactions for use in eventLoader
  List<TransactionModel>? _cachedTransactions;

  List<TransactionModel> _getEventsForDay(DateTime day) {
    // Use cached transactions if available
    final allTransactions = _cachedTransactions ?? [];

    // Filter transactions for the specific day
    final selectedDate = DateTime(day.year, day.month, day.day);
    return allTransactions
        .where((transaction) =>
            DateTime(transaction.date.year, transaction.date.month, transaction.date.day)
                .isAtSameMomentAs(selectedDate))
        .toList();
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

        // Cache transactions for the eventLoader
        _cachedTransactions = allTransactions;

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
                    color: const Color(0xFF0A7F66), // Emerald Deep Green
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions for this day',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A7F66), // Emerald Deep Green (same as budgets page)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap on a date with transactions to view details',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF0A7F66), // Emerald Deep Green
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