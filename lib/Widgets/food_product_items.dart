import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:food_delivery_app/Model/product_model.dart';
import 'package:food_delivery_app/Provider/cart_provider.dart';
import 'package:food_delivery_app/View/product_detail_page.dart';
import 'package:food_delivery_app/consts.dart';
import 'package:food_delivery_app/Model/favorite_model.dart';
import 'package:food_delivery_app/Services/favorite_service.dart';
import 'package:food_delivery_app/Services/favorite_service_sqlite.dart';
import 'package:food_delivery_app/Services/favorite_service_web.dart';
import 'package:food_delivery_app/Provider/favorite_provider.dart';

class FoodProductItems extends StatelessWidget {
  final MyProductModel productModel;
  const FoodProductItems({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: productModel),
          ),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            height: 225,
            width: size.width / 2.4,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            height: 285,
            width: size.width / 2.4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 160,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kblack.withOpacity(0.3),
                                  spreadRadius: 10,
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Hero(
                          tag: productModel.image,
                          child: Image.asset(productModel.image, height: 150),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    productModel.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rate_rounded,
                        color: kyellow,
                        size: 22,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        productModel.rate.toString(),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.color!.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on, color: kpink, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        "${productModel.distance}m",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.color!.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "\$${productModel.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ❤️ Иконка "в избранное"
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () async {
                final favorite = FavoriteModel(
                  name: productModel.name,
                  image: productModel.image,
                  price: productModel.price,
                  rate: productModel.rate,
                  distance: productModel.distance,
                );

                Provider.of<FavoriteProvider>(
                  context,
                  listen: false,
                ).addFavorite(favorite);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to favorites")),
                );
              }, // <-- здесь ты пропустил запятую/закрытие функции
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // 🛒 Иконка "в корзину"
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                cartProvider.addCart(productModel);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: kblack,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
