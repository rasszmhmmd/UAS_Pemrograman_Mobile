import 'package:flutter/material.dart';
import '../models/store.dart';
import '../services/api_service.dart';
import 'deal_list_page.dart';

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  late Future<List<Store>> futureStores;

  @override
  void initState() {
    super.initState();
    futureStores = ApiService().fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Store yang ingin diketahui', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Store>>(
          future: futureStores,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load stores'));
            } else if (snapshot.hasData) {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final store = snapshot.data![index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealListPage(storeID: store.storeID),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            store.logo,
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text(store.storeName, style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No stores available'));
            }
          },
        ),
      ),
    );
  }
}
