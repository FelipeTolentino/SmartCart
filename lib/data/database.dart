import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DAO_cart.dart';

Future<Database> getDatabase() async {
  final String path = join( await getDatabasesPath(), 'tasks.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(DAOCart.carts);
    db.execute(DAOCart.cartItems);
  }, version: 1);
}