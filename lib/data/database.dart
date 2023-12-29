import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DAO_cart.dart';

Future<Database> getDatabase() async {
  final String path = join( await getDatabasesPath(), 'smartcart.db');
  return openDatabase(path, onCreate: (db, version) async {
    print("criando database");
    await db.execute(DAOCart.carts);
    await db.execute(DAOCart.cartItems);
  }, version: 1);
}

Future<void> deleteDatabase(String dbName) async {
  databaseFactory.deleteDatabase(join(await getDatabasesPath(), '$dbName.db'));
}