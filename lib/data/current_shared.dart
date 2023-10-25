import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/cart_item.dart';
import '../components/history_cart_item.dart';

class Cart {
  Cart({
    required this.description,
    required this.market,
    required this.date,
  });

  String description;
  String market;
  String date;
  List<CartItem> items = [];
  int itemQuantity = 0;
  double totalPrice = 0;

  void addItem({
    required String description,
    required double price,
    required int quantity,
    required BuildContext cartContext }) {
    items.add(
        CartItem(
            description: description,
            quantity: quantity,
            price: price,
            cartContext: cartContext
        )
    );
  }

  void updateCart() {
    itemQuantity = 0;
    totalPrice = 0;
    for (final item in items) {
      itemQuantity += item.quantity;
      totalPrice += item.price * item.quantity;
    }
  }

  List<HistoryCartItem> convertToHistoryItems() {
    final List<HistoryCartItem> historyItems = [];
    for (final item in items) {
      historyItems.add(HistoryCartItem(
          description: item.description,
          quantity: item.quantity,
          price: item.price
      ));
    }

    return historyItems;
  }
}

class CurrentShared extends InheritedWidget {
  CurrentShared({
    super.key,
    required Widget child,
    required this.cart
  }) : super(child: child);

  Cart cart;
  Function()? refreshCartScreen;

  static CurrentShared of(BuildContext context) {
    final CurrentShared? result = context.dependOnInheritedWidgetOfExactType<CurrentShared>();
    assert(result != null, 'No CurrentShared found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CurrentShared oldWidget) {
    return oldWidget.cart.itemQuantity != cart.itemQuantity;
  }
}
