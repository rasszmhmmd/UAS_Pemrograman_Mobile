import 'package:flutter/material.dart';
import '../models/deal.dart';

class DealDetailPage extends StatelessWidget {
  final Deal deal;

  DealDetailPage({required this.deal});

  // Fungsi untuk mengonversi harga USD ke Rupiah
  String convertToRupiah(String price) {
    double usdPrice = double.tryParse(price) ?? 0.0;
    double idrPrice = usdPrice * 15000; // Misal 1 USD = 15000 IDR
    return idrPrice.toStringAsFixed(0); // Menghilangkan desimal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deal.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                deal.thumb,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Harga Diskon: Rp${convertToRupiah(deal.salePrice)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                'Harga Normal: Rp${convertToRupiah(deal.normalPrice)}',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                'Steam Rating: ${deal.steamRatingText}',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                'Deal Rating: ${deal.dealRating}',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
