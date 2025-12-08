import 'package:flutter/material.dart';

class CheckboxGrid extends StatefulWidget {
  final List<bool> checkboxStates;
  final Function(int, bool) onCheckboxChanged;
  final int itemsPerRow;
  final double itemSize;

  const CheckboxGrid({
    Key? key,
    required this.checkboxStates,
    required this.onCheckboxChanged,
    this.itemsPerRow = 5,
    this.itemSize = 50,
  }) : super(key: key);

  @override
  State<CheckboxGrid> createState() => _CheckboxGridState();
}

class _CheckboxGridState extends State<CheckboxGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.itemsPerRow,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: widget.checkboxStates.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onCheckboxChanged(index, !widget.checkboxStates[index]);
          },
          child: Container(
            width: widget.itemSize,
            height: widget.itemSize,
            decoration: BoxDecoration(
              color: widget.checkboxStates[index] 
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.checkboxStates[index] 
                    ? Colors.green
                    : Colors.grey.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                widget.checkboxStates[index] 
                    ? Icons.check
                    : null,
                color: widget.checkboxStates[index] 
                    ? Colors.green
                    : Colors.transparent,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}