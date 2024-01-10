import 'package:flutter/material.dart';
import 'package:smartcart/data/DAO_cart.dart';
import 'package:smartcart/models/cart.dart';

class History extends ChangeNotifier {
  List<Cart> carts = [];

  History({required this.carts});

  Future<int> deleteCart(int cartIndex) async {
    var result = await DAOCart().deleteCart(carts[cartIndex].id);

    if (result > 0) {
      carts.removeAt(cartIndex);
      notifyListeners();
    }

    return result;
  }

  Cart getCart(int cartIndex) {
    return carts[cartIndex];
  }

  int getCartID(int cartIndex) {
    return carts[cartIndex].id;
  }
}