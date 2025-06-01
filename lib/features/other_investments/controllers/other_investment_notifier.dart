import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/other_investment_model.dart';

class OtherInvestmentNotifier extends StateNotifier<OtherInvestment> {
  OtherInvestmentNotifier()
      : super(OtherInvestment(
    investmentType: '',
    corpus: 0,
    annualReturnRate: 0,
  ));

  void updateType(String type) {
    state = state.copyWith(investmentType: type);
  }

  void updateCorpus(double value) {
    state = state.copyWith(corpus: value);
  }

  void updateReturnRate(double value) {
    state = state.copyWith(annualReturnRate: value);
  }
}

final otherInvestmentProvider =
StateNotifierProvider<OtherInvestmentNotifier, OtherInvestment>(
        (ref) => OtherInvestmentNotifier());
