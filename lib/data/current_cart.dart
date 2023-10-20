import 'package:flutter/material.dart';
import '../components/cart_item.dart';

class CurrentCart extends InheritedWidget {
  CurrentCart({
    super.key,
    required Widget child,
  }) : super(child: child);

  static CurrentCart of(BuildContext context) {
    final CurrentCart? result = context.dependOnInheritedWidgetOfExactType<CurrentCart>();
    assert(result != null, 'No CurrentCart found in context');
    return result!;
  }

  String cartName = 'Nova Compra';
  String marketName = 'Mercado';
  String date = '18/10/2023';

  List<CartItem> items = [];
  int cartItemQnty = 0;
  double cartPrice = 0;

  Function()? refreshCartScreen;

  void addItem({
    required String name,
    required double price,
    required int quantity,
    required BuildContext cartContext }) {
    items.add(
      CartItem(
        name: name,
        quantity: quantity,
        price: price,
        cartContext: cartContext
      )
    );
  }

  void updateCart() {
    cartItemQnty = 0;
    cartPrice = 0;
    for (final item in items) {
      cartItemQnty += item.quantity;
      cartPrice += item.price * item.quantity;
    }
  }

  String formatCurrency(String input) {
    input = input.replaceAll(',', ".");
    input = '${input.substring(0, input.length - 3)},${input.substring(input.length - 2)}';
    return input;
  }

  @override
  bool updateShouldNotify(CurrentCart oldWidget) {
    return oldWidget.cartItemQnty != cartItemQnty;
  }
}
