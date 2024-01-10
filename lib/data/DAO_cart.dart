import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:smartcart/models/cart.dart';
import 'package:smartcart/models/item.dart';
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
  'item_name TEXT,'
  'item_price ,'
  'item_quantity INTEGER,'
  'from_cart INTEGER,'
  'FOREIGN KEY (from_cart) REFERENCES carts(cart_id)'
  ');';

  Future<int> saveCart(Cart cart) async {
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

  Future<int> deleteCart(int cartID) async {
    final Database db = await getDatabase();
    int result = await db.delete(
        'carts',
        where: 'cart_id = ?',
        whereArgs: [cartID]
    );

    return result;
  }

  Future<Cart> getCart(int cartID) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> cartsMap = await db.query(
        'carts',
        where: 'cart_id = ?',
        whereArgs: [cartID]
    );

    var cartMap = cartsMap.first;
    Cart cart = Cart.history(
        id: cartMap['cart_id'],
        description: cartMap['cart_description'],
        market: cartMap['market_name'],
        date: cartMap['date'],
        itemQuantity: cartMap['total_items'],
        totalPrice: cartMap['cart_price']
    );

    cart.setItems(items: await getCartItems(cartID));

    return cart;
  }

  Future<List<Cart>> getAllCarts() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> cartsMap = await db.query('carts');
    final List<Cart> carts = [];
    for (Map<String, dynamic> cart in cartsMap) {
      carts.add(Cart.history(
          id: cart['cart_id'], 
          description: cart['cart_description'], 
          market: cart['market_name'], 
          date: cart['date'], 
          itemQuantity: cart['total_items'],
          totalPrice: cart['cart_price']
      ));
    }
    
    return carts;
  }

  Future<List<Item>> getCartItems(int cartId) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> itemsMap = await db.query(
      'cart_items',
      where: 'from_cart = ?',
      whereArgs: [cartId]
    );

    List<Item> items = [];
    for (var itemMap in itemsMap) {
      items.add(mapToItem(itemMap));
    }

    return items;
  }

  Item mapToItem(Map<String, dynamic> itemMap) {
    return Item(
      name: itemMap['item_name'],
      price: itemMap['item_price'],
      quantity: itemMap['item_quantity']
    );
  }

  Map<String, dynamic> itemToMap(Item item, int cartID) {
    final Map<String, dynamic> itemMap = {};
    itemMap['item_name'] = item.name;
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
}