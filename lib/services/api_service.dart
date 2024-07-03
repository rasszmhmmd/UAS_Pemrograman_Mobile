import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/deal.dart';
import '../models/store.dart';

class ApiService {
  static const String apiUrlDeals = 'https://www.cheapshark.com/api/1.0/deals?storeID=1&upperPrice=50';
  static const String apiUrlStores = 'https://www.cheapshark.com/api/1.0/stores';

  Future<List<Deal>> fetchDeals(String storeID) async {
    final response = await http.get(Uri.parse('https://www.cheapshark.com/api/1.0/deals?storeID=$storeID&upperPrice=50'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((deal) => Deal.fromJson(deal)).toList();
    } else {
      throw Exception('Failed to load deals');
    }
  }

  Future<List<Store>> fetchStores() async {
    final response = await http.get(Uri.parse(apiUrlStores));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((store) => Store.fromJson(store)).toList();
    } else {
      throw Exception('Failed to load stores');
    }
  }
}
