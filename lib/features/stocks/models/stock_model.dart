import '../../../data/models/stock.dart';

class StockInvestment {
  final int quantity;
  final String company;
  final double buyPrice;
  final List phaseInvestments; // e.g. '2024-01-01–2024-06-30' => shares + amount

  StockInvestment({
    required this.quantity,
    required this.company,
    required this.buyPrice,
    required this.phaseInvestments,
  });
}

class StockPhase {
  final int quantity;
  final double amount;

  StockPhase({required this.quantity, required this.amount});
}

class SelectedStock {
  final IndustryStock stock;
  final int quantity;

  SelectedStock({required this.stock, required this.quantity});
}
