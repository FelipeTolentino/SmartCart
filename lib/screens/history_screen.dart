import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartcart/models/history.dart';
import 'package:smartcart/models/cart.dart';
import 'package:smartcart/components/history_cart_card.dart';
import '../data/DAO_cart.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return FutureBuilder<List<Cart>>(
      future: DAOCart().getAllCarts(),
      builder: (context, snapshot) {
        List<Cart>? carts = snapshot.data;
        switch(snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData && carts != null) {
              if (carts.isNotEmpty) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (context) => History(carts: carts))
                  ],
                  child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: const Color.fromARGB(255, 96, 232, 142),
                        title: const Text('Histórico',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        titleSpacing: 30,
                      ),
                      body: Center(
                        child: SizedBox(
                          height: 800, width: 370,
                          child: Consumer<History>(
                            builder: (BuildContext newContext, History history, _) {
                              if (history.carts.length > 0) {
                                return ListView.builder(
                                  itemCount: history.carts.length,
                                  itemBuilder: (context, index) {
                                    return HistoryCartCard(
                                      cartIndex: index,
                                    );
                                  },
                                );
                              }
                              else {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.highlight_remove, size: 70, color: Color.fromARGB(255, 96, 232, 142)),
                                      Text('Não há carrinhos no histórico',
                                          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 96, 232, 142))
                                      )
                                    ],
                                  ),
                                );
                              }
                            }
                          )
                        ),
                      )
                  ),
                );
              }
              else {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.highlight_remove, size: 70, color: Color.fromARGB(255, 96, 232, 142)),
                      Text('Não há carrinhos no histórico',
                          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 96, 232, 142))
                      )
                    ],
                  ),
                );
              }
            }
            else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 70, color: Color.fromARGB(255, 96, 232, 142)),
                    Text('Algo deu errado. Não foi possível carregar o histórico',
                        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 96, 232, 142))
                    )
                  ],
                ),
              );
            }

          default:
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Carregando')
                ]
              )
            );
        }
      }
    );
  }
}
