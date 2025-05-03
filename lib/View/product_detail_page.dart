import 'package:flutter/material.dart';
import 'package:food_delivery_app/Model/product_model.dart';
import 'package:food_delivery_app/View/cart.dart';
import 'package:food_delivery_app/consts.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/Provider/cart_provider.dart'; // Добавили

class ProductDetailPage extends StatelessWidget {
  final MyProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'hero_${product.name}',
                child: Image.asset(
                  product.image,
                  height: 200,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                ),
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
            Text(
              "Description:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            Text(product.description),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: korange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  cartProvider.addCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.name} added to cart!',
                        style: const TextStyle(color: Colors.white),
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: korange,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: korange,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text("Go to Cart"),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => const Cart(),
              transitionsBuilder: (_, animation, __, child) {
                const begin = Offset(0.0, 1.0); // Снизу вверх
                const end = Offset.zero;
                final tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: Curves.easeInOut));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
      ),
    );
  }
}
