class MutualFundModel {
  final String id;
  final String commonName;
  final String? schemeType; // Make nullable

  MutualFundModel({
    required this.id,
    required this.commonName,
    required this.schemeType,

  });

  factory MutualFundModel.fromJson(Map<String, dynamic> json) {
    return MutualFundModel(
      id: json['id'],
      commonName: json['schemeName'],
      schemeType: json['schemeType'], // Now allowed to be null

    );
  }
}


class SelectedMf {
  final MutualFund mf;
  final String name;
  final int quantity;
  List phases;


  SelectedMf({required this.mf, required this.quantity, required this.name, required this.phases});
}


class MutualFund {
  final String? fundName;
  final String? category;
  final String? riskLevel;
  final String? planType;
  final String? schemeType;
  final String? inceptionDate;
  final String? benchmark;
  final String? benchmarkName;
  final double? fundSize;
  final String? fundManager;
  final String? registrarAgent;
  final double? faceValue;
  final String? nfoRisk;

  final double? currentNav;
  final String? navDate;

  final Map<String, double>? absoluteReturns;
  final Map<String, double>? cagrReturns;
  final Map<String, double>? categoryReturns;
  final Map<String, double>? indexReturns;

  final double? alpha;
  final double? beta;
  final double? sharpeRatio;
  final double? sortinoRatio;
  final double? standardDeviation;
  final int? riskRating;

  MutualFund({
    this.fundName,
    this.category,
    this.riskLevel,
    this.planType,
    this.schemeType,
    this.inceptionDate,
    this.benchmark,
    this.benchmarkName,
    this.fundSize,
    this.fundManager,
    this.registrarAgent,
    this.faceValue,
    this.nfoRisk,
    this.currentNav,
    this.navDate,
    this.absoluteReturns,
    this.cagrReturns,
    this.categoryReturns,
    this.indexReturns,
    this.alpha,
    this.beta,
    this.sharpeRatio,
    this.sortinoRatio,
    this.standardDeviation,
    this.riskRating,
  });

  factory MutualFund.fromJson(Map<String, dynamic> json) {
    final basic = json['basic_info'] ?? {};
    final nav = json['nav_info'] ?? {};
    final returns = json['returns'] ?? {};
    final riskMetrics = returns['risk_metrics'] ?? {};

    Map<String, double>? _toDoubleMap(Map<String, dynamic>? map) {
      if (map == null) return null;
      return map.map((key, value) {
        final val = value;
        return MapEntry(key, (val is num) ? val.toDouble() : 0.0);
      });
    }

    return MutualFund(
      fundName: basic['fund_name'],
      category: basic['category'],
      riskLevel: basic['risk_level'],
      planType: basic['plan_type'],
      schemeType: basic['scheme_type'],
      inceptionDate: basic['inception_date'],
      benchmark: basic['benchmark'],
      benchmarkName: basic['benchmark_name'],
      fundSize: (basic['fund_size'] is num) ? (basic['fund_size'] as num).toDouble() : null,
      fundManager: basic['fund_manager'],
      registrarAgent: basic['registrar_agent'],
      faceValue: (basic['face_value'] is num) ? (basic['face_value'] as num).toDouble() : null,
      nfoRisk: basic['nfo_risk'],
      currentNav: (nav['current_nav'] is num) ? (nav['current_nav'] as num).toDouble() : null,
      navDate: nav['nav_date'],
      absoluteReturns: _toDoubleMap(returns['absolute']),
      cagrReturns: _toDoubleMap(returns['cagr']),
      categoryReturns: _toDoubleMap(returns['category_returns']),
      indexReturns: _toDoubleMap(returns['index_returns']),
      alpha: (riskMetrics['alpha'] is num) ? (riskMetrics['alpha'] as num).toDouble() : null,
      beta: (riskMetrics['beta'] is num) ? (riskMetrics['beta'] as num).toDouble() : null,
      sharpeRatio: (riskMetrics['sharpe_ratio'] is num) ? (riskMetrics['sharpe_ratio'] as num).toDouble() : null,
      sortinoRatio: (riskMetrics['sortino_ratio'] is num) ? (riskMetrics['sortino_ratio'] as num).toDouble() : null,
      standardDeviation: (riskMetrics['standard_deviation'] is num)
          ? (riskMetrics['standard_deviation'] as num).toDouble()
          : null,
      riskRating: (riskMetrics['risk_rating'] is int) ? riskMetrics['risk_rating'] : null,
    );
  }
}

