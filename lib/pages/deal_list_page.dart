import 'package:flutter/material.dart';
import '../models/deal.dart';
import '../services/api_service.dart';
import 'deal_detail_page.dart';

class DealListPage extends StatefulWidget {
  final String storeID;

  DealListPage({required this.storeID});

  @override
  _DealListPageState createState() => _DealListPageState();
}

class _DealListPageState extends State<DealListPage> {
  late Future<List<Deal>> futureDeals;
  List<Deal> deals = [];
  String selectedSort = 'Title';

  String convertToRupiah(String price) {
    double usdPrice = double.tryParse(price) ?? 0.0;
    double idrPrice = usdPrice * 15000; // Misal 1 USD = 15000 IDR
    return idrPrice.toStringAsFixed(0); // Menghilangkan desimal
  }

  @override
  void initState() {
    super.initState();
    futureDeals = ApiService().fetchDeals(widget.storeID);
    futureDeals.then((loadedDeals) {
      setState(() {
        deals = loadedDeals;
        sortDeals(selectedSort);
      });
    });
  }

  void sortDeals(String criteria) {
    setState(() {
      selectedSort = criteria;
      if (criteria == 'Title') {
        deals.sort((a, b) => a.title.compareTo(b.title));
      } else if (criteria == 'Price') {
        deals.sort((a, b) => double.parse(a.salePrice).compareTo(double.parse(b.salePrice)));
      } else if (criteria == 'Rating') {
        deals.sort((a, b) => double.parse(b.dealRating).compareTo(double.parse(a.dealRating)));
      } else if (criteria == 'Discount') {
        deals.sort((a, b) => double.parse(b.savings).compareTo(double.parse(a.savings)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Deals'),
        actions: [
          DropdownButton<String>(
            value: selectedSort,
            icon: Icon(Icons.sort),
            onChanged: (String? newValue) {
              sortDeals(newValue!);
            },
            items: <String>['Title', 'Price', 'Rating', 'Discount']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<Deal>>(
        future: futureDeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load deals'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: deals.length,
              itemBuilder: (context, index) {
                // Calculate discount percentage
                final originalPrice = double.parse(deals[index].normalPrice);
                final salePrice = double.parse(deals[index].salePrice);
                final discountPercentage = ((originalPrice - salePrice) / originalPrice * 100).toStringAsFixed(1);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: Image.network(
                        deals[index].thumb,
                        width: 120.0,
                        height: 45.0,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        deals[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text('Rp${convertToRupiah(deals[index].salePrice)}'),
                          SizedBox(height: 5),
                          Text('${deals[index].dealRating}/10'),
                          SizedBox(height: 5),
                          Text('Deals: $discountPercentage%'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealDetailPage(deal: deals[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No deals available'));
          }
        },
      ),
    );
  }
}
