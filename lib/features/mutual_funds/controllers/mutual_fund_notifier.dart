import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_planner/data/repositories/investment_repository.dart';
import '../../../data/models/stock.dart';
import '../../stocks/models/stock_model.dart';
import '../models/mutual_fund_model.dart';

class StockInvestmentState {
  final String ticker;
  final String company;
  final double currentPrice;
  final Map<String, StockPhase> phaseInvestments;

  StockInvestmentState({
    this.ticker = '',
    this.company = '',
    this.currentPrice = 0.0,
    Map<String, StockPhase>? phaseInvestments,
  }) : phaseInvestments = phaseInvestments ?? {};

  StockInvestmentState copyWith({
    String? ticker,
    String? company,
    double? currentPrice,
    Map<String, StockPhase>? phaseInvestments,
  }) {
    return StockInvestmentState(
      ticker: ticker ?? this.ticker,
      company: company ?? this.company,
      currentPrice: currentPrice ?? this.currentPrice,
      phaseInvestments: phaseInvestments ?? this.phaseInvestments,
    );
  }

  bool get isValid => ticker.isNotEmpty && phaseInvestments.isNotEmpty;
}

class MutualFundNotifier extends StateNotifier<StockInvestmentState> {
  MutualFundNotifier() : super(StockInvestmentState());

  void setStockDetails({
    required String ticker,
    required String company,
    required double currentPrice,
  }) {
    state = state.copyWith(
      ticker: ticker,
      company: company,
      currentPrice: currentPrice,
    );
  }

  Future<List<MutualFundModel>> searchIndustry(String query) async {
    final response = await InvestmentRepository().fetchMfs(query);

    if (true) {
      final data = response as List;
      return data.map((e) => MutualFundModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load industry stocks');
    }
  }



}

final mutualFundProvider =
StateNotifierProvider<MutualFundNotifier, StockInvestmentState>(
        (ref) => MutualFundNotifier());
