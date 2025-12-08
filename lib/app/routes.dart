import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
import '../feature/pin/set_pin_page.dart';
import '../feature/pin/verify_pin_page.dart';
import '../feature/settings/add_budget_page.dart';
import '../feature/settings/budget_limit_page.dart';
import '../feature/settings/edit_budget_page.dart';
import '../feature/settings/export_page.dart';
import '../feature/settings/notification_settings_page.dart';
import '../feature/saving_goals/saving_goals_list_page.dart';
import '../feature/saving_goals/create_goal_page.dart';
import '../feature/saving_goals/goal_detail_page.dart';
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
        currentIndex: 0, // Transactions page is now at index 0 (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Transactions',
        child: const TransactionListPage(),
      ),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard_main',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page is now at index 0 (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Transactions',
        child: const TransactionListPage(),
      ),
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page is now at index 0 (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Transactions',
        child: const TransactionListPage(),
      ),
    ),
    GoRoute(
      path: '/transactions/add',
      name: 'add_transaction',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page index (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Add Transaction',
        showBottomNavBar: false,
        showBackButton: false,
        child: const AddTransactionPage(),
      ),
    ),
    GoRoute(
      path: '/transactions/edit/:id',
      name: 'edit_transaction',
      builder: (context, state) => MainLayout(
        currentIndex: 0, // Transactions page index (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Edit Transaction',
        showBottomNavBar: false,
        showBackButton: false,
        child: EditTransactionPage(transactionId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/budgets',
      name: 'budgets',
      builder: (context, state) => MainLayout(
        currentIndex: 1, // Budgets page is now at index 1 (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Budgets',
        child: const BudgetLimitPage(), // Using budget limit page as the budgets page
      ),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => MainLayout(
        currentIndex: 4, // Settings page (transactions=0, budgets=1, overview=2, calendar=3, settings=4)
        title: 'Settings',
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      path: '/settings/notifications',
      name: 'settings_notifications',
      builder: (context, state) => MainLayout(
        currentIndex: 4, // Notifications page (transactions=0, budgets=1, overview=2, calendar=3, settings=4) - same as settings
        title: 'Notifications',
        child: const NotificationSettingsPage(isInMainLayout: true),
      ),
    ),
    GoRoute(
      path: '/saving-goals',
      name: 'saving_goals',
      builder: (context, state) => MainLayout(
        currentIndex: 4, // Settings page (transactions=0, budgets=1, overview=2, calendar=3, settings=4)
        title: 'Saving Goals',
        child: const SavingGoalsListPage(),
        floatingActionButton: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () async {
              if (FirebaseAuth.instance.currentUser == null) {
                // Show login prompt
                final shouldLogin = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Login Required'),
                    content: const Text('You need to login to create saving goals. Would you like to login now?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                );

                if (shouldLogin == true) {
                  GoRouter.of(context).push('/login');
                }
              } else {
                GoRouter.of(context).push('/saving-goals/create');
              }
            },
            backgroundColor: Colors.transparent,
            heroTag: "add_saving_goal_fab", // Consistent with budget page approach
            elevation: 0,
            highlightElevation: 0,
            focusElevation: 0,
            disabledElevation: 0,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    ),
    GoRoute(
      path: '/saving-goals/create',
      name: 'create_saving_goal',
      builder: (context, state) => MainLayout(
        currentIndex: 4, // Settings page index (transactions=0, budgets=1, overview=2, calendar=3, settings=4)
        title: 'Create Goal',
        child: const CreateGoalPage(),
      ),
    ),
    GoRoute(
      path: '/saving-goals/:id',
      name: 'saving_goal_detail',
      builder: (context, state) => MainLayout(
        currentIndex: 4, // Settings page (transactions=0, budgets=1, overview=2, calendar=3, settings=4)
        title: 'Goal Detail',
        child: GoalDetailPage(goalId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/saving-goals/edit/:id',
      name: 'edit_saving_goal',
      redirect: (context, state) => '/saving-goals/${state.pathParameters['id']}', // For now, redirect to detail page since we don't have a dedicated edit page yet
    ),
    GoRoute(
      path: '/wallet', // Keep the path for backward compatibility or redirect
      name: 'wallet',
      redirect: (context, state) => '/calendar', // Redirect wallet path to calendar
    ),
    GoRoute(
      path: '/overview',
      name: 'overview',
      builder: (context, state) => MainLayout(
        currentIndex: 2, // Overview at index 2 (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Overview',
        child: const OverviewPage(),
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
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
        currentIndex: 1, // Budgets page index (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Budgets',
        child: const BudgetLimitPage(),
      ),
    ),
    GoRoute(
      path: '/budgets/add',
      name: 'add_budget',
      builder: (context, state) => MainLayout(
        currentIndex: 1, // Budgets page index (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Add Budget',
        showBottomNavBar: false,
        showBackButton: false,
        child: const AddBudgetPage(),
      ),
    ),
    GoRoute(
      path: '/budgets/edit/:id',
      name: 'edit_budget',
      builder: (context, state) => MainLayout(
        currentIndex: 1, // Budgets page index (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Edit Budget',
        showBottomNavBar: false,
        showBackButton: false,
        child: EditBudgetPage(budgetId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/calendar',
      name: 'calendar',
      builder: (context, state) => MainLayout(
        currentIndex: 3, // Calendar at index 3 (transactions=0, budgets=1, overview=2, calendar=3, settings=4)
        title: 'Calendar',
        child: const CalendarPage(),
      ),
    ),
    GoRoute(
      path: '/export',
      name: 'export',
      builder: (context, state) => MainLayout(
        currentIndex: 4, // Settings page index (transactions=0, budgets=1, overview=2, calendar=3, settings=4)
        title: 'Export',
        child: const ExportPage(),
      ),
    ),
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      builder: (context, state) => MainLayout(
        currentIndex: 2, // Analytics at index 2 (transactions=0, budgets=1, analytics=2, settings=3)
        title: 'Analytics',
        child: const AnalyticsPage(),
      ),
    ),
  ],
);
