enum InvestmentType {
  mutualFund,
  stocks,
  providentFund,
  other,
}

class InvestmentOption {
  final InvestmentType type;
  final String name;

  const InvestmentOption({required this.type, required this.name});
}


class InvestmentEntry {
  final String name;
  final double amount;

  InvestmentEntry({required this.name, required this.amount});
}
