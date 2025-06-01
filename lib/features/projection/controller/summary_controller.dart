import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/investment_projection.dart';

// Provider holding the list of projection items
final summaryProjectionProvider =
StateNotifierProvider<SummaryProjectionController, List<SummaryProjectionItem>>(
      (ref) => SummaryProjectionController(),
);

final selectedTabIndexProvider = StateProvider<int>((ref) => 0);


class SummaryProjectionController extends StateNotifier<List<SummaryProjectionItem>> {
  SummaryProjectionController() : super([]);



  // Example method to add or update an investment's projection
  void addOrUpdateProjection({
    required String title,
    required double principal,
    required double annualReturnRate,
    required int years,
  }) {
    // Let's define the 3 phases as roughly 1/3, 2/3, and full period projections
    final phase1Years = (years / 3).ceil();
    final phase2Years = (2 * years / 3).ceil();
    final phase3Years = years;

    double calculateFutureValue(double principal, double rate, int years) {
      double amount = principal;
      for (int i = 0; i < years; i++) {
        amount = amount * (1 + rate / 100);
      }
      return amount;
    }

    final phase1 = calculateFutureValue(principal, annualReturnRate, phase1Years);
    final phase2 = calculateFutureValue(principal, annualReturnRate, phase2Years);
    final phase3 = calculateFutureValue(principal, annualReturnRate, phase3Years);

    // Check if item exists already, update it or add new
    final index = state.indexWhere((element) => element.title == title);

    final newItem = SummaryProjectionItem(
      title: title,
      phase1: phase1,
      phase2: phase2,
      phase3: phase3,
    );

    if (index == -1) {
      state = [...state, newItem];
    } else {
      final updatedList = [...state];
      updatedList[index] = newItem;
      state = updatedList;
    }
  }

  // Optional: clear all projections
  void clear() => state = [];
}
