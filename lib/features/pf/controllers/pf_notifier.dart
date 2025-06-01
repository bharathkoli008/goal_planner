import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pf_model.dart';

class PfInputNotifier extends StateNotifier<PfInputModel> {
  PfInputNotifier()
      : super(PfInputModel(
    totalCorpus: 0,
    annualContribution: 0,
    interestRate: 8, // default interest rate
  ));

  void updateCorpus(double value) {
    state = state.copyWith(totalCorpus: value);
  }

  void updateContribution(double value) {
    state = state.copyWith(annualContribution: value);
  }

  void updateInterestRate(double value) {
    state = state.copyWith(interestRate: value);
  }
}

final pfInputProvider = StateNotifierProvider<PfInputNotifier, PfInputModel>(
      (ref) => PfInputNotifier(),
);
