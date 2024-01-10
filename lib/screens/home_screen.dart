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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 232, 142),
        title: const Text('Home',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500
            )
        ),
        titleSpacing: 30,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 100, 35, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: ElevatedButton(
                  onPressed: (){
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 96, 232, 142),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    minimumSize: const Size(300, 100)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Icon(Icons.add_shopping_cart_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Text('Novo Carrinho',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: ElevatedButton(
                  onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Ainda em desenvolvimento'),
                            behavior: SnackBarBehavior.floating
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 96, 232, 142),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      minimumSize: const Size(300, 100)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Icon(Icons.edit_note,
                          color: Colors.white,
                          size: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Text('Listas de Compras',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (newContext) => const HistoryScreen()
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 96, 232, 142),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      minimumSize: const Size(300, 100)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Icon(Icons.history,
                          color: Colors.white,
                          size: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Text('Histórico',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
