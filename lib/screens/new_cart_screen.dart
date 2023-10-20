import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:smartcart/data/current_cart.dart';
import 'package:smartcart/screens/cart_screen.dart';

class NewCartScreen extends StatelessWidget {
  const NewCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 96, 232, 142),
      leading: const SizedBox(),
      title: const Text('Adicionar Novo Carrinho'),
    ),
      body: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DottedBorder(
                borderType: BorderType.Circle,
                dashPattern: const [10, 10],
                strokeWidth: 5,
                child: Ink(
                  padding: const EdgeInsets.all(15),
                  decoration: const ShapeDecoration(
                      color: Color.fromARGB(255, 96, 232, 142),
                      shape: CircleBorder()
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart,
                          color: Colors.white
                      ),
                      iconSize: 100,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (newContext) => CurrentCart(child: CartScreen())));
                      }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) => states.contains(MaterialState.selected) ?
                  const TextStyle(color: Colors.white) :
                  const TextStyle(color: Colors.white)
          )
        ),
        child: NavigationBar(
          height: 100,
          backgroundColor: const Color.fromARGB(255, 96, 232, 142),
          indicatorShape: const CircleBorder(),
          indicatorColor: const Color.fromARGB(255, 88, 200, 131),
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.add_shopping_cart, color: Colors.white, size: 50),
                label: 'Novo Carrinho'
            ),
            NavigationDestination(
                icon: Icon(Icons.history, color: Colors.white, size: 50),
                label: 'Novo Carrinho'
            ),
          ],
        ),
      ),
    );
  }
}
