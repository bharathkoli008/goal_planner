import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'target_controller.g.dart';

@riverpod
class TargetController extends _$TargetController {
  @override
  TargetState build() => TargetState();

  void setGoalName(String name) => state = state.copyWith(goalName: name);
  void setAmount(String amount) => state = state.copyWith(targetAmount: amount);
  void setTargetYear(String year) => state = state.copyWith(targetYear: year);
  void setInflationRate(String rate) => state = state.copyWith(inflationRate: rate);

  void setPhase(int index, String fromYear, String toYear) {
    final updatedPhases = [...state.phases];
    if (index < updatedPhases.length) {
      updatedPhases[index] = (fromYear, toYear);
    } else {
      updatedPhases.add((fromYear, toYear));
    }
    state = state.copyWith(phases: updatedPhases);
  }
  void setPhaseInflation(int index, String rate) {
    final updatedInflations = [...state.phaseInflations];
    if (index < updatedInflations.length) {
      updatedInflations[index] = rate;
    } else {
      updatedInflations.add(rate);
    }
    state = state.copyWith(phaseInflations: updatedInflations);
  }

  void autoGeneratePhases({int startYear = 2024}) {
    final int? endYear = int.tryParse(state.targetYear);
    if (endYear == null || endYear <= startYear) return;

    final int totalYears = endYear - startYear + 1;
    final int chunkSize = (totalYears / 3).ceil();

    List<(String, String)> newPhases = [];
    List<String> newInflations = [];

    for (int i = 0; i < 3; i++) {
      final from = startYear + i * chunkSize;
      final to = (from + chunkSize - 1).clamp(startYear, endYear);
      if (from <= endYear) {
        newPhases.add((from.toString(), to.toString()));
        newInflations.add(state.inflationRate); // Default inflation for each phase
      }
    }

    state = state.copyWith(phases: newPhases, phaseInflations: newInflations);
  }


  void setTargetYears(String year) {
    state = state.copyWith(targetYear: year);
    autoGeneratePhases();
  }

}

class TargetState {
  final String goalName;
  final String targetAmount;
  final String targetYear;
  final String inflationRate;
  final List<(String, String)> phases;
  final List<String> phaseInflations; // NEW

  TargetState({
    this.goalName = '',
    this.targetAmount = '',
    this.targetYear = '2024',
    this.inflationRate = '',
    this.phases = const [],
    this.phaseInflations = const ['', '', ''], // default 3 empty slots
  });

  TargetState copyWith({
    String? goalName,
    String? targetAmount,
    String? targetYear,
    String? inflationRate,
    List<(String, String)>? phases,
    List<String>? phaseInflations, // NEW
  }) {
    return TargetState(
      goalName: goalName ?? this.goalName,
      targetAmount: targetAmount ?? this.targetAmount,
      targetYear: targetYear ?? this.targetYear,
      inflationRate: inflationRate ?? this.inflationRate,
      phases: phases ?? this.phases,
      phaseInflations: phaseInflations ?? this.phaseInflations,
    );
  }
}

