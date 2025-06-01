class OtherInvestment {
  final String investmentType;
  final double corpus;
  final double annualReturnRate; // in %

  OtherInvestment({
    required this.investmentType,
    required this.corpus,
    required this.annualReturnRate,
  });

  OtherInvestment copyWith({
    String? investmentType,
    double? corpus,
    double? annualReturnRate,
  }) {
    return OtherInvestment(
      investmentType: investmentType ?? this.investmentType,
      corpus: corpus ?? this.corpus,
      annualReturnRate: annualReturnRate ?? this.annualReturnRate,
    );
  }

  Map<String, dynamic> toJson() => {
    'investmentType': investmentType,
    'corpus': corpus,
    'annualReturnRate': annualReturnRate,
  };

  factory OtherInvestment.fromJson(Map<String, dynamic> json) {
    return OtherInvestment(
      investmentType: json['investmentType'] ?? '',
      corpus: (json['corpus'] ?? 0).toDouble(),
      annualReturnRate: (json['annualReturnRate'] ?? 0).toDouble(),
    );
  }
}
