import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../state/saving_goals_provider.dart';
import '../../data/models/saving_goal_model.dart';
import '../../core/widgets/swipeable_saving_goal_card.dart';

class SavingGoalsListPage extends StatelessWidget {
  const SavingGoalsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SavingGoalsProvider>(
      builder: (context, provider, child) {
        final goals = provider.goals;

        if (goals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 80,
                    color: const Color(0xFF0A7F66), // Match the green color scheme used throughout the app
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No saving goals yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // Make the text bold as requested
                      color: const Color(0xFF0A7F66), // Match the green color scheme
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first saving goal to start tracking',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF0A7F66), // Match the green color scheme
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return SwipeableSavingGoalCard(goal: goal);
            },
          ),
        );
      },
    );
  }
}