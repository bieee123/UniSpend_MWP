import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UniSpendBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onAddTransactionPressed;

  const UniSpendBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onAddTransactionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Transactions button (index 0)
            _buildNavButton(
              context: context,
              index: 0,
              currentIndex: currentIndex,
              icon: Icons.list,
              label: 'Transactions',
              onTap: () => _navigateTo(context, '/transactions'),
            ),

            // Budgets button (index 1)
            _buildNavButton(
              context: context,
              index: 1,
              currentIndex: currentIndex,
              icon: Icons.pie_chart,
              label: 'Budgets',
              onTap: () => _navigateTo(context, '/budget-limit'), // Using budget limit page
            ),

            // Overview button (index 2)
            _buildNavButton(
              context: context,
              index: 2,
              currentIndex: currentIndex,
              icon: Icons.dashboard,
              label: 'Overview',
              onTap: () => _navigateTo(context, '/overview'),
            ),

            // Calendar button (index 3)
            _buildNavButton(
              context: context,
              index: 3,
              currentIndex: currentIndex,
              icon: Icons.calendar_today,
              label: 'Calendar',
              onTap: () => _navigateTo(context, '/calendar'),
            ),

            // Settings button (index 4)
            _buildNavButton(
              context: context,
              index: 4,
              currentIndex: currentIndex,
              icon: Icons.settings,
              label: 'Settings',
              onTap: () => _navigateTo(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: currentIndex == index ? Theme.of(context).primaryColor : Colors.grey,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: currentIndex == index ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String location) {
    // Simply navigate to the location - navigation state management is handled by GoRouter
    context.go(location);
  }
}