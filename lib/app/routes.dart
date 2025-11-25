import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pages
import '../feature/Auth/login_page.dart';
import '../feature/Auth/register_page.dart';
import '../feature/Auth/forgot_password_page.dart';
import '../feature/Auth/verify_email_page.dart';
import '../feature/dashboard/dashboard_page.dart';
import '../feature/transactions/add_transaction_page.dart';
import '../feature/transactions/transaction_list_page.dart';
import '../feature/transactions/edit_transaction_page.dart';
import '../feature/settings/settings_page.dart';
import '../feature/categories/category_list_page.dart';
import '../feature/categories/add_category_page.dart';
import '../feature/categories/edit_category_page.dart';
import '../feature/pin/set_pin_page.dart';
import '../feature/pin/verify_pin_page.dart';
import '../feature/settings/budget_limit_page.dart';
import '../feature/settings/export_page.dart';
import '../feature/settings/notification_settings_page.dart';
import '../feature/calendar/calendar_page.dart';
import '../feature/analytics/analytics_page.dart';
import '../feature/splash/splash_screen.dart';
import '../feature/dashboard/overview_page.dart';
import '../core/widgets/main_layout.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page is now at index 0 (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Transactions',
        child: const TransactionListPage(),
      ),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard_main',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page is now at index 0 (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Transactions',
        child: const TransactionListPage(),
      ),
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page is now at index 0 (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Transactions',
        child: const TransactionListPage(),
      ),
    ),
    GoRoute(
      path: '/transactions/add',
      name: 'add_transaction',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Add Transaction',
        child: const AddTransactionPage(),
      ),
    ),
    GoRoute(
      path: '/transactions/edit/:id',
      name: 'edit_transaction',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Edit Transaction',
        child: EditTransactionPage(transactionId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/budgets',
      name: 'budgets',
      builder: (context, state) => MainLayout(
        currentIndex: 1, // Budgets page is now at index 1 (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Budgets',
        child: const BudgetLimitPage(), // Using budget limit page as the budgets page
      ),
    ),
    GoRoute(
      path: '/categories/add',
      name: 'add_category',
      builder: (context, state) => MainLayout(
        currentIndex: 1, // Budgets page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Add Category',
        child: const AddCategoryPage(),
      ),
    ),
    GoRoute(
      path: '/categories/edit/:id',
      name: 'edit_category',
      builder: (context, state) => MainLayout(
        currentIndex: 1, // Budgets page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Edit Category',
        child: EditCategoryPage(categoryId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => MainLayout(
        currentIndex: 3, // Settings page (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Settings',
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      path: '/settings/notifications',
      name: 'settings_notifications',
      builder: (context, state) => MainLayout(
        currentIndex: 3, // Notifications page (transactions=0, budgets=1, wallet=2, settings=3) - same as settings
        title: 'Notifications',
        child: const NotificationSettingsPage(),
      ),
    ),
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      builder: (context, state) => MainLayout(
        currentIndex: 2, // Wallet page (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Wallet',
        child: const Center(child: Text('Wallet Page - Coming Soon')), // Will implement wallet page later
      ),
    ),
    GoRoute(
      path: '/overview',
      name: 'overview',
      builder: (context, state) => const OverviewPage(), // Replaces dashboard - shows expenses by category
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot_password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/verify-email',
      name: 'verify_email',
      builder: (context, state) => const VerifyEmailPage(),
    ),
    GoRoute(
      path: '/set-pin',
      name: 'set_pin',
      builder: (context, state) => const SetPINPage(),
    ),
    GoRoute(
      path: '/verify-pin',
      name: 'verify_pin',
      builder: (context, state) => VerifyPINPage(nextRoute: state.uri.queryParameters['next']),
    ),
    GoRoute(
      path: '/budget-limit',
      name: 'budget_limit',
      builder: (context, state) => MainLayout(
        currentIndex: 1, // Budgets page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Budget Limit',
        child: const BudgetLimitPage(),
      ),
    ),
    GoRoute(
      path: '/calendar',
      name: 'calendar',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Calendar',
        child: const CalendarPage(),
      ),
    ),
    GoRoute(
      path: '/export',
      name: 'export',
      builder: (context, state) => MainLayout(
        currentIndex: 3, // Settings page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Export',
        child: const ExportPage(),
      ),
    ),
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page index (transactions=0, budgets=1, wallet=2, settings=3)
        title: 'Analytics',
        child: const AnalyticsPage(),
      ),
    ),
  ],
);
