class IndustryStock {
  final String id;
  final String commonName;
  final String? mgIndustry; // Make nullable
  final String? mgSector;   // Make nullable
  final String stockType;
  final String? exchangeCodeBse;
  final String? exchangeCodeNsi;
  final String? bseRic;
  final String? nseRic;

  IndustryStock({
    required this.id,
    required this.commonName,
    required this.mgIndustry,
    required this.mgSector,
    required this.stockType,
    required this.exchangeCodeBse,
    required this.exchangeCodeNsi,
    required this.bseRic,
    required this.nseRic,
  });

  factory IndustryStock.fromJson(Map<String, dynamic> json) {
    return IndustryStock(
      id: json['id'],
      commonName: json['commonName'],
      mgIndustry: json['mgIndustry'], // Now allowed to be null
      mgSector: json['mgSector'],     // Same here
      stockType: json['stockType'],
      exchangeCodeBse: json['exchangeCodeBse'],
      exchangeCodeNsi: json['exchangeCodeNsi'],
      bseRic: json['bseRic'],
      nseRic: json['nseRic'],
    );
  }
}
