class PfInputModel {
  final double totalCorpus;
  final double annualContribution;
  final double interestRate;

  PfInputModel({
    required this.totalCorpus,
    required this.annualContribution,
    required this.interestRate,
  });

  PfInputModel copyWith({
    double? totalCorpus,
    double? annualContribution,
    double? interestRate,
  }) {
    return PfInputModel(
      totalCorpus: totalCorpus ?? this.totalCorpus,
      annualContribution: annualContribution ?? this.annualContribution,
      interestRate: interestRate ?? this.interestRate,
    );
  }
}
