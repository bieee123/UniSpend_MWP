import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final String title;
  final bool showBottomNavBar;
  final bool showBackButton;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const MainLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.title,
    this.showBottomNavBar = true,
    this.showBackButton = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showBackButton
          ? AppBar(
              title: Text(widget.title),
              // Changed to Emerald Deep Green
              backgroundColor: const Color(0xFF0A7F66), // Emerald Deep Green
              foregroundColor: Colors.white,
            )
          : AppBar(
              title: Text(widget.title),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Changed to Emerald Deep Green
              backgroundColor: const Color(0xFF0A7F66), // Emerald Deep Green
              foregroundColor: Colors.white,
            ),
      body: SafeArea(
        bottom: !widget.showBottomNavBar, // Don't apply safe area at the bottom if bottom nav is hidden
        child: Column(
          children: [
            Expanded(child: widget.child),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNavBar
          ? UniSpendBottomNavBar(
              currentIndex: widget.currentIndex,
              onAddTransactionPressed: () {
                context.go('/calendar'); // Center button now goes to calendar page
              },
            )
          : null,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}