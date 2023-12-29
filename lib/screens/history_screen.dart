import 'package:flutter/material.dart';
import 'package:smartcart/components/history_cart_card.dart';
import 'package:smartcart/data/DAO_cart.dart';
import 'package:sqflite/sqflite.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: FutureBuilder<List<HistoryCartCard>>(
            future: DAOCart().findAll(),
            builder: (context, snapshot) {
              List<HistoryCartCard>? carts = snapshot.data;
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(
                      child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Carregando')
                          ]
                      )
                  );
                case ConnectionState.waiting:
                  return const Center(
                      child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Carregando')
                          ]
                      )
                  );
                case ConnectionState.active:
                  return const Center(
                      child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Carregando')
                          ]
                      )
                  );
                case ConnectionState.done:
                  if (snapshot.hasData && carts != null) {
                    if (carts.isNotEmpty) {
                      var reversedCarts = carts.reversed.toList();
                      return ListView.builder(
                        itemCount: carts.length,
                        itemBuilder: (context, index) {
                          return reversedCarts[index];
                        },
                      );
                    }
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
            }
          )
        ),
      )
    );
  }
}
