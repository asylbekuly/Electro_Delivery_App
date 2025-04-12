// lib/View/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Model/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final MyProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: product.image, // Тот же тег
                child: Image.asset(product.image, height: 200),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text("\$${product.price}", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Text("Rating: ${product.rate} ⭐"),
            const SizedBox(height: 10),
            Text("Distance: ${product.distance}m"),
            const SizedBox(height: 20),
            Text("Description: ${product.description}"),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
