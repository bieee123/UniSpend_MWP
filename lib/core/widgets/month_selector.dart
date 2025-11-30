import 'package:flutter/material.dart';

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final int initialIndex;
  final Function(int) onMonthChanged;

  const MonthSelector({
    Key? key,
    required this.months,
    this.initialIndex = 0,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Scrollbar(
        thickness: 0, // Make scrollbar invisible
        thumbVisibility: false, // Hide scrollbar thumb
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.months.length,
          itemBuilder: (context, index) {
            bool isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onMonthChanged(index);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? null : Colors.grey[200],
                  gradient: isSelected
                    ? const LinearGradient(
                        colors: [Colors.green, Colors.teal],
                      )
                    : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    widget.months[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}