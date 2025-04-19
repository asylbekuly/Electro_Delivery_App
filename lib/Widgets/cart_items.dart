import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/Model/cart_model.dart';
import 'package:food_delivery_app/Provider/cart_provider.dart';
import 'package:food_delivery_app/View/product_detail_page.dart';

class CartItems extends StatelessWidget {
  final CartModel cart;
  const CartItems({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: cart.productModel),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove from cart'),
            content: const Text(
              'Are you sure you want to remove this item from the cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  cartProvider.removeCart(cart.productModel);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      child: SizedBox(
        height: 140,
        width: size.width / 1.2,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 130,
              width: size.width - 50,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              top: -5,
              left: 0,
              child: SizedBox(
                height: 130,
                width: 130,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 100,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(cart.productModel.image, width: 130),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 150,
              right: 20,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.productModel.name,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rate_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            cart.productModel.rate.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                      .withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.pink,
                            size: 20,
                          ),
                          Text(
                            "${cart.productModel.distance}m",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                      .withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${(cart.productModel.price).toStringAsFixed(2)}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (cart.quantity > 1) {
                                cartProvider
                                    .recuceQuantity(cart.productModel);
                              }
                            },
                            child: Container(
                              width: 25,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).iconTheme.color,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(7),
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            cart.quantity.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              cartProvider.addCart(cart.productModel);
                            },
                            child: Container(
                              width: 25,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).iconTheme.color,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(7),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
