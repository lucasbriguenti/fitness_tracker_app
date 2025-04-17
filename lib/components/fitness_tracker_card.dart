import 'package:flutter/material.dart';

class FitnessTrackerCard extends StatelessWidget {
  final Widget child;
  const FitnessTrackerCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: child,
    );
  }
}
