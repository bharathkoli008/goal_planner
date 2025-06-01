import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../mutual_funds/models/mutual_fund_model.dart';
import '../../other_investments/models/other_investment_model.dart';
import '../../pf/models/pf_model.dart';
import '../../stocks/models/stock_model.dart';
import '../models/investment_option.dart';


class InvestmentData {
  List<SelectedMf> mutualFunds;
  final List<StockInvestment> stocks;
  final List<PfInputModel> providentFunds;
  final List<OtherInvestment> others;

  InvestmentData({
    this.mutualFunds = const [],
    this.stocks = const [],
    this.providentFunds = const [],
    this.others = const [],
  });

  InvestmentData copyWith({
    List<SelectedMf>? mutualFunds,
    List<StockInvestment>? stocks,
    List<PfInputModel>? providentFunds,
    List<OtherInvestment>? others,
  }) {
    return InvestmentData(
      mutualFunds: mutualFunds ?? this.mutualFunds,
      stocks: stocks ?? this.stocks,
      providentFunds: providentFunds ?? this.providentFunds,
      others: others ?? this.others,
    );
  }
}

class InvestmentController extends StateNotifier<InvestmentData> {
  InvestmentController() : super(InvestmentData());

  void addInvestment(InvestmentType type, entry) {
    switch (type) {
      case InvestmentType.mutualFund:
        state = state.copyWith(mutualFunds: [...state.mutualFunds, entry]);
        break;
      case InvestmentType.stocks:
        state = state.copyWith(stocks: [...state.stocks, entry]);
        break;
      case InvestmentType.providentFund:
        state = state.copyWith(providentFunds: [...state.providentFunds, entry]);
        break;
      case InvestmentType.other:
        state = state.copyWith(others: [...state.others, entry]);
        break;
    }
  }

  void clear() {
    state = state.copyWith(mutualFunds: []);
    state = state.copyWith(stocks: []);
    state = state.copyWith(providentFunds: []);
    state = state.copyWith(others: []);

  }

  int countOf(InvestmentType type) {
    switch (type) {
      case InvestmentType.mutualFund:
        return state.mutualFunds.length;
      case InvestmentType.stocks:
        return state.stocks.length;
      case InvestmentType.providentFund:
        return state.providentFunds.length;
      case InvestmentType.other:
        return state.others.length;
    }
  }
}

final investmentProvider = StateNotifierProvider<InvestmentController, InvestmentData>(
      (ref) => InvestmentController(),
);
