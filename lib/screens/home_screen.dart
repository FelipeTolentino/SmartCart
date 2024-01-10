import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartcart/data/DAO_cart.dart';
import 'package:smartcart/models/history.dart';
import 'package:smartcart/screens/cart_screen.dart';
import '../models/cart.dart';
import 'package:smartcart/screens/history_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List<Cart>? carts;
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) => states.contains(MaterialState.selected) ?
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w600) :
                  const TextStyle(color: Color.fromRGBO(0, 130, 13, 0.6), fontWeight: FontWeight.w600)
          ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
                (Set<MaterialState> states) => states.contains(MaterialState.selected) ?
                  const IconThemeData(color: Colors.white) :
                  const IconThemeData(color: Color.fromRGBO(0, 130, 13, 0.6))
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: const Color.fromARGB(255, 100, 232, 142),
          indicatorShape: const CircleBorder(),
          indicatorColor: const Color.fromRGBO(100, 232, 142, 0),
          //indicatorSize: ,
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.add_shopping_cart, size: 30),
                label: 'Novo Carrinho'
            ),
            NavigationDestination(
                icon: Icon(Icons.history, size: 30),
                label: 'Histórico'
            ),
          ],
          onDestinationSelected: (selectedPageIndex) {
            setState(() { currentPageIndex = selectedPageIndex; });
          },
        ),
      ),
      body: <Widget>[
        SizedBox(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Ink(
                  padding: const EdgeInsets.all(15),
                  decoration: const ShapeDecoration(
                      color: Color.fromARGB(255, 96, 232, 142),
                      shape: CircleBorder()
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart,
                          color: Colors.white
                      ),
                      iconSize: 80,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (newContext) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(create: (newContext) => Cart())
                              ],
                              child: const CartScreen(),
                            )
                        )).then((finished) {
                          if (finished) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Carrinho salvo!'),
                                  behavior: SnackBarBehavior.floating,
                                )
                            );
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Desculpe! Um erro ocorreu...'),
                                    behavior: SnackBarBehavior.floating
                                )
                            );
                          }
                        });
                      }
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Novo Carrinho', style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          ),
        ),
        const HistoryScreen()
      ][currentPageIndex]
    );
  }
}
