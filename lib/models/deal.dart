class Deal {
  final String title;
  final String dealID;
  final String thumb;
  final String salePrice;
  final String normalPrice;
  final String steamRatingText;
  final String dealRating;
  final String savings;

  Deal({
    required this.title,
    required this.dealID,
    required this.thumb,
    required this.salePrice,
    required this.normalPrice,
    required this.steamRatingText,
    required this.dealRating,
    required this.savings,

  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      title: json['title'],
      dealID: json['dealID'],
      thumb: json['thumb'],
      salePrice: json['salePrice'],
      normalPrice: json['normalPrice'],
      steamRatingText: json['steamRatingText'] ?? 'No Rating',
      dealRating: json['dealRating'] ?? '0',
      savings: json['savings'],

    );
  }
}
