import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../state/saving_goals_provider.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  State<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _unitAmountController = TextEditingController(); // Empty by default

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _unitAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define a common style for form input cards
    BoxDecoration getFormCardDecoration() {
      return BoxDecoration(
        color: const Color(0xFF0A7F66).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0A7F66).withOpacity(0.3),
          width: 1,
        ),
      );
    }

    Widget buildFormCard({required String title, required Widget child, double? minHeight}) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: getFormCardDecoration(),
        constraints: minHeight != null ? BoxConstraints(minHeight: minHeight) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0A7F66),
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Goal Name
                    buildFormCard(
                      title: "Goal Name",
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Enter goal name (e.g., New phone, Vacation)",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF0A7F66),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a goal name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Target Amount
                    buildFormCard(
                      title: "Target Amount (Rp)",
                      child: TextFormField(
                        controller: _targetAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0",
                          prefix: Text(
                            "Rp ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0A7F66),
                            ),
                          ),
                          hintStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF0A7F66),
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter target amount';
                          }
                          final amount = double.tryParse(value.replaceAll(',', ''));
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            try {
                              final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                              if (cleanValue.isNotEmpty) {
                                int number = int.parse(cleanValue);
                                String formatted = number.toString().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},');
                                _targetAmountController.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: formatted.length),
                                  ),
                                );
                              }
                            } catch (e) {
                              // If parsing fails, keep the value as is
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Saving Unit
                    buildFormCard(
                      title: "Saving Unit (Rp)",
                      child: TextFormField(
                        controller: _unitAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0",
                          prefix: Text(
                            "Rp ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0A7F66),
                            ),
                          ),
                          hintStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF0A7F66),
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter saving unit amount';
                          }
                          final amount = double.tryParse(value.replaceAll(',', ''));
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            try {
                              final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                              if (cleanValue.isNotEmpty) {
                                int number = int.parse(cleanValue);
                                String formatted = number.toString().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},');
                                _unitAmountController.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: formatted.length),
                                  ),
                                );
                              }
                            } catch (e) {
                              // If parsing fails, keep the value as is
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Preview section - using the same form card style as other input cards
                    buildFormCard(
                      title: "Preview",
                      minHeight: 200, // Increased minimum height for consistent sizing
                      child: _PreviewSection(
                        targetAmountController: _targetAmountController,
                        unitAmountController: _unitAmountController,
                        nameController: _nameController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Create Goal Button - Positioned at the bottom outside the scrollable area
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A7F66), Color(0xFF076C72)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ElevatedButton(
              onPressed: _createGoal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  "Create Saving Goal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createGoal() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if user is authenticated before creating goal
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
        // Navigate to login with return route
        context.go('/login');
      }
      return; // Don't proceed with goal creation
    }

    final targetText = _targetAmountController.text.replaceAll(',', '');
    final unitText = _unitAmountController.text.replaceAll(',', '');

    final targetAmount = double.tryParse(targetText) ?? 0;
    final unitAmount = double.tryParse(unitText) ?? 0;

    if (targetAmount <= 0 || unitAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid amounts'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final provider = context.read<SavingGoalsProvider>();
      await provider.addGoal(
        name: _nameController.text.trim(),
        targetAmount: targetAmount,
        unitAmount: unitAmount,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saving goal created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/saving-goals');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating goal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _PreviewSection extends StatefulWidget {
  final TextEditingController targetAmountController;
  final TextEditingController unitAmountController;
  final TextEditingController? nameController; // Optional name controller to include in preview

  const _PreviewSection({
    required this.targetAmountController,
    required this.unitAmountController,
    this.nameController,
  });

  @override
  State<_PreviewSection> createState() => _PreviewSectionState();
}

class _PreviewSectionState extends State<_PreviewSection> {
  @override
  void initState() {
    super.initState();
    // Add listeners to trigger rebuilds when text changes
    widget.targetAmountController.addListener(_onTextChanged);
    widget.unitAmountController.addListener(_onTextChanged);
    widget.nameController?.addListener(_onTextChanged); // Listen to name changes if provided
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    widget.targetAmountController.removeListener(_onTextChanged);
    widget.unitAmountController.removeListener(_onTextChanged);
    widget.nameController?.removeListener(_onTextChanged); // Remove name listener if provided
    super.dispose();
  }

  void _onTextChanged() {
    // Trigger a rebuild when text changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final targetText = widget.targetAmountController.text.replaceAll(',', '');
    final unitText = widget.unitAmountController.text.replaceAll(',', '');
    final goalName = widget.nameController?.text.trim() ?? '';

    final targetAmount = double.tryParse(targetText) ?? 0;
    final unitAmount = double.tryParse(unitText) ?? 0;

    final totalUnits = (targetAmount > 0 && unitAmount > 0) ? (targetAmount / unitAmount).ceil() : 0;
    final estimatedTime = (targetAmount > 0 && unitAmount > 0) ? (targetAmount / unitAmount).ceil() : 0;

    // Calculate target completion date (1000 weeks from today as example)
    final today = DateTime.now();
    final targetDate = estimatedTime > 0 ? today.add(Duration(days: estimatedTime * 7)) : today; // Convert weeks to days

    // Format the target date
    String formattedTargetDate = '${targetDate.day} ${_getMonthName(targetDate.month)} ${targetDate.year}';

    // Use dummy current saved units as specified
    final currentSavedUnits = 100;
    final progressPercentage = totalUnits > 0 ? (currentSavedUnits / totalUnits) * 100 : 0;

    // Clamp progress between 0 and 100
    final clampedProgress = progressPercentage > 100 ? 1.0 : (progressPercentage / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: clampedProgress,
          minHeight: 8,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0A7F66)), // Green accent color
        ),
        const SizedBox(height: 12),

        // Goal Title with Icon
        Row(
          children: [
            Icon(
              Icons.laptop_chromebook,
              color: const Color(0xFF0A7F66),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Goal: ${goalName.isEmpty ? 'new laptop' : goalName}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0A7F66),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Target Amount
        Text(
          targetAmount > 0 ?
          'Target: Rp ${targetAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}' :
          'Target: Rp 0',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: targetAmount > 0 ? Colors.grey[800] : Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),

        // Per Saving Unit
        Text(
          unitAmount > 0 ?
          'Per saving unit: Rp ${unitAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}' :
          'Per saving unit: Rp 0',
          style: TextStyle(
            fontSize: 14,
            color: unitAmount > 0 ? Colors.grey[700] : Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),

        // Total Units Needed
        Text(
          'Total units needed: ${totalUnits > 0 ? totalUnits.toString() : '0'}',
          style: TextStyle(
            fontSize: 14,
            color: totalUnits > 0 ? Colors.grey[700] : Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),

        // Progress Status
        Text(
          'Current progress: $currentSavedUnits/${totalUnits > 0 ? totalUnits.toString() : '0'} saved',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),

        // Target Date
        Text(
          'Target Date: $formattedTargetDate',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0A7F66), // Accent color for target date
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}