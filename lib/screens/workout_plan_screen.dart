import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkoutPlanScreen extends StatelessWidget {
  final String workoutPlan;

  const WorkoutPlanScreen({
    super.key,
    required this.workoutPlan,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.workoutPlan),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          workoutPlan,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
