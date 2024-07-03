class Store {
  final String storeID;
  final String storeName;
  final String logo;
  final String icon;

  Store({
    required this.storeID,
    required this.storeName,
    required this.logo,
    required this.icon,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeID: json['storeID'],
      storeName: json['storeName'],
      logo: 'https://www.cheapshark.com${json['images']['logo']}',
      icon: 'https://www.cheapshark.com${json['images']['icon']}',
    );
  }
}
