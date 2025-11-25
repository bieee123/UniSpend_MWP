import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final String title;

  const MainLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.title,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: _shouldShowBackButton(),
      ),
      body: Column(
        children: [
          Expanded(child: widget.child),
          // Add the custom bottom navigation bar
          UniSpendBottomNavBar(
            currentIndex: widget.currentIndex,
            onAddTransactionPressed: () {
              context.go('/overview'); // Center button now goes to overview page
            },
          ),
        ],
      ),
    );
  }

  bool _shouldShowBackButton() {
    // For now, always show back button, can be refined later
    return true;
  }
}