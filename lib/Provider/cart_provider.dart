import 'package:flutter/material.dart';
import 'package:food_delivery_app/Model/cart_model.dart';
import 'package:food_delivery_app/Model/product_model.dart';

class CartProvider with ChangeNotifier {
  // private list _carts to store cart items, each represented by a cartModel
  List<CartModel> _carts = [];

  // getter for _Carts to access the list of cart items
  List<CartModel> get carts => _carts;

  // setter for _Carts. updates the cart list and notifies listeners when it changes.
  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners(); // Notifies any widgets listening to this provider to rebuild.
  }

  // Adds a product to the cart.
  addCart(MyProductModel productModel) {
    if (productExist(productModel)) {
      // Finds the index of the product in the cart.
      int index = _carts.indexWhere(
        (element) => element.productModel == productModel,
      );
      // Increments the quantity of the product by 1 if it already exists.
      _carts[index].quantity = _carts[index].quantity + 1;
    } else {
      // Adds a new CartModel item with quantity 1 if the product doesn't exist in the cart.
      _carts.add(CartModel(productModel: productModel, quantity: 1));
    }
    notifyListeners(); // Update
  }

  // Increases the quantity of a specific product in the cart by 1.
  addQuantity(MyProductModel product) {
    // Finds the index of the product in the cart.
    int index = _carts.indexWhere((element) => element.productModel == product);
    // Increments the quantity by 1.
    _carts[index].quantity = _carts[index].quantity + 1;
    notifyListeners(); // Update the quantity change.
  }

  // Decreases the quantity of a specific product in the cart by 1.
  recuceQuantity(MyProductModel product) {
    // Finds the index of the product in the cart.
    int index = _carts.indexWhere((element) => element.productModel == product);
    // Decrements the quantity by 1.
    _carts[index].quantity = _carts[index].quantity - 1;
    notifyListeners(); // Update the quantity change.
  }

  void removeCart(MyProductModel productModel) {
    _carts.removeWhere((element) => element.productModel == productModel);
    notifyListeners();
  }

  // Checks if a product already exists in the cart.
  // Returns true if the product is in the cart, false otherwise.
  productExist(MyProductModel productModel) {
    if (_carts.indexWhere((element) => element.productModel == productModel) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }

  // Calculates the total price of all items in the cart.
  double totalCart() {
    double total = 0; // Initialize the total to 0.
    for (var i = 0; i < _carts.length; i++) {
      // Adds the price for each cart item.
      total = total + _carts[i].quantity * _carts[i].productModel.price;
    }
    return total; // Returns the total price of all cart items.
  }
}
