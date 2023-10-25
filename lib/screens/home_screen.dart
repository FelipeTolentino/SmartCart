import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartcart/data/current_shared.dart';
import 'package:smartcart/screens/cart_screen.dart';
import 'package:smartcart/screens/history_screen.dart';

class NewCartScreen extends StatefulWidget {
  const NewCartScreen({super.key});

  @override
  State<NewCartScreen> createState() => _NewCartScreenState();
}

class _NewCartScreenState extends State<NewCartScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                            builder: (newContext) => CurrentShared(
                              cart: Cart(
                                description: 'Nova Compra',
                                market: 'Mercado',
                                date: DateFormat('dd/MM/yyyy').format(DateTime.now())
                              ),
                              child: CartScreen(homeContext: context)
                            )
                        ));
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
        const History()
      ][currentPageIndex]
    );
  }
}
