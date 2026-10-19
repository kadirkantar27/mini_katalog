import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // Uyarıyı çözen satır
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // Asset'ten JSON okuma ve State güncelleme
  Future<void> loadProducts() async {
    String jsonString = await DefaultAssetBundle.of(context).loadString('assets/products.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    
    setState(() {
      products = jsonList.map((item) => Product.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // İstenilen Banner Görseli
          Image.network(
            'https://wantapi.com/assets/banner.png',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              color: Colors.grey[300],
              child: const Center(child: Text('Banner Yüklenemedi')),
            ),
          ),
          
          Expanded(
            child: products.isEmpty
                ? const Center(child: CircularProgressIndicator()) 
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      childAspectRatio: 0.75, 
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          // Route Arguments kullanımı
                          Navigator.pushNamed(
                            context, 
                            '/detail', 
                            arguments: product,
                          );
                        },
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(product.image, fit: BoxFit.contain),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text('${product.price} TL', style: const TextStyle(color: Colors.green)),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}