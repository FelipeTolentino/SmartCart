import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartcart/components/history_cart_card.dart';
import 'package:smartcart/data/current_shared.dart';
import 'package:sqflite/sqflite.dart';

import '../components/cart_item.dart';
import 'database.dart';

class DAOCart{
  static const String carts = 'CREATE TABLE carts ('
    'cart_id INTEGER PRIMARY KEY AUTOINCREMENT,'
    'cart_description TEXT,'
    'market_name TEXT,'
    'date VARCHAR(10),'
    'total_items INTEGER,'
    'cart_price REAL'
    ');';

  static const String cartItems = 'CREATE TABLE cart_items ('
  'item_id INTEGER PRIMARY KEY AUTOINCREMENT,'
  'item_description TEXT,'
  'item_price ,'
  'item_quantity INTEGER,'
  'from_cart INTEGER,'
  'FOREIGN KEY (from_cart) REFERENCES carts(cart_id)'
  ');';

  Future<int> save(Cart cart) async {
    final Database db = await getDatabase();

    var cartValues = cartToMap(cart);
    int cartID = await db.insert('carts', cartValues);
    if (cartID == 0) return 1;

    for (final item in cart.items) {
      var itemValues = itemToMap(item, cartID);
      await db.insert('cart_items', itemValues);
    }

    return 0;
  }

  Future<List<HistoryCartCard>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> cartsMap = await db.query('carts');
    final List<HistoryCartCard> carts = [];
    for (Map<String, dynamic> cart in cartsMap) {
      carts.add(HistoryCartCard(
          id: cart['cart_id'], 
          description: cart['cart_description'], 
          market: cart['market_name'], 
          date: cart['date'], 
          itemQuantity: cart['total_items'],
          price: cart['cart_price']
      ));
    }
    
    return carts;
  }

  Future<Cart> findThis(int cartID, BuildContext cartContext) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> cartsMap = await db.query(
      'carts',
      where: 'cart_id = ?',
      whereArgs: [cartID]
    );

    final List<Cart> carts = [];

    for(Map<String, dynamic> cartMap in cartsMap) {
      carts.add(Cart(
        description: cartMap['cart_description'],
        market: cartMap['market_name'],
        date: cartMap['date']
      ));

      final List<Map<String, dynamic>> itemsMap = await db.query(
        'cart_items',
        where: 'from_cart = ?',
        whereArgs: [cartID]
      );

      if (!cartContext.mounted) {
        return Cart(
            description: 'Nova Compra',
            market: 'Mercado',
            date: DateFormat('dd/MM/yyyy').format(DateTime.now())
        );
      }

      for (Map<String, dynamic> itemMap in itemsMap) {
        carts.first.addItem(
            description: itemMap['item_description'],
            price: itemMap['item_price'],
            quantity: itemMap['item_quantity'],
            cartContext: cartContext
        );
      }

      carts.first.updateCart();
    }

    return carts.first;
  }

  Map<String, dynamic> itemToMap(CartItem item, int cartID) {
    final Map<String, dynamic> itemMap = {};
    itemMap['item_description'] = item.description;
    itemMap['item_price'] = item.price;
    itemMap['item_quantity'] = item.quantity;
    itemMap['from_cart'] = cartID;

    return itemMap;
  }

  Map<String, dynamic> cartToMap(Cart cart) {
    final Map<String, dynamic> cartMap = {};
    cartMap['cart_description'] = cart.description;
    cartMap['market_name'] = cart.market;
    cartMap['date'] = cart.date;
    cartMap['total_items'] = cart.itemQuantity;
    cartMap['cart_price'] = cart.totalPrice;

    return cartMap;
  }

// findLastCart() async {
//   final Database db = await getDatabase();
//   final List<Map<String, dynamic>> cart = await db.query(
//     'carts',
//     orderBy: 'id DESC',
//     limit: 1
//   );
//
//   return cart;
// }
}