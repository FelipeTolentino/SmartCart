import 'package:sqflite/sqflite.dart';

import '../components/cart_item.dart';
import 'database.dart';

class DAOCart{
  static const String carts = 'CREATE TABLE carts ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT,'
    'cart_description TEXT,'
    'market_name TEXT,'
    'date DATE'
    ');';

  static const String cartItems = 'CREATE TABLE cart_items ('
  'id INTEGER PRIMARY KEY AUTOINCREMENT,'
  'item_description TEXT,'
  'item_price ,'
  'item_quantity INTEGER,'
  'from_cart INTEGER,'
  'FOREIGN KEY (from_cart) REFERENCES carts(id)'
  ');';

  Future<int> save(List<CartItem> items, String description, String market) async {
    final Database db = await getDatabase();

    var cartValues = cartToMap(description, market);
    int cartID = await db.insert('carts', cartValues);
    if (cartID == 0) return 1;

    for (final item in items) {
      var itemValues = itemToMap(item, cartID);
      await db.insert('cart_items', itemValues);
    }

    return 0;
  }

  Map<String, dynamic> itemToMap(CartItem item, int cartID) {
    final Map<String, dynamic> itemMap = {};
    itemMap['item_description'] = item.name;
    itemMap['item_price'] = item.price;
    itemMap['item_quantity'] = item.quantity;
    itemMap['from_cart'] = cartID;

    return itemMap;
  }

  Map<String, dynamic> cartToMap(String description, String marketName) {
    final Map<String, dynamic> cartMap = {};
    cartMap['cart_description'] = description;
    cartMap['market_name'] = marketName;

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