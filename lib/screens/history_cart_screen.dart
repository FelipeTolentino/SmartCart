import 'package:flutter/material.dart';
import 'package:smartcart/components/history_item_card.dart';
import 'package:text_scroll/text_scroll.dart';
import '../utils/utils.dart';
import './popups/confirm_dialog.dart';
import 'package:smartcart/models/item.dart';
import 'package:smartcart/models/history.dart';

class HistoryCartScreen extends StatefulWidget {
  const HistoryCartScreen({required this.history, required this.cartIndex, super.key});

  final History history;
  final int cartIndex;

  @override
  State<HistoryCartScreen> createState() => _HistoryCartScreenState();
}

class _HistoryCartScreenState extends State<HistoryCartScreen> {
  @override
  Widget build(BuildContext context) {
    var cart = widget.history.getCart(widget.cartIndex);
    return FutureBuilder<List<Item>>(
      future: cart.queryItems(),
      builder: (context, snapshot) {
        var items = snapshot.data;
        switch(snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData && items != null) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 96, 232, 142),
                  leading: BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: TextScroll(
                      '${cart.description} - ${cart.market} - ${cart.date}       ',
                      velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                      delayBefore: const Duration(seconds: 8),
                      pauseBetween: const Duration(seconds: 5),
                      style: const TextStyle(fontSize: 15, color: Colors.white)
                  ),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (newContext) => ConfirmDialog(
                                  title: "Apagando Carrinho",
                                  message: "Esta ação irá apagar o carrinho permanentemente. Deseja continuar?"
                              )
                          ).then((confirmed) async {
                            if (confirmed) {
                              var result = await widget.history.deleteCart(widget.cartIndex);
                              if (result > 0) {
                                Navigator.pop(context);
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Um erro ocorreu!'),
                                      behavior: SnackBarBehavior.floating,
                                    )
                                );
                              }
                              // await DAOCart().listAll();
                            }
                          });
                        }
                    )
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      Container(
                          height: 85,
                          color: const Color.fromARGB(255, 96, 232, 142),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.shopping_basket, size: 35, color: Colors.black54),
                                      ),
                                      Text(cart.itemQuantity > 1 ?
                                      '${cart.itemQuantity} itens' : '1 item',
                                          style: const TextStyle(
                                              fontSize: 20, fontWeight:
                                          FontWeight.w400,
                                              color: Colors.black54
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 165,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('TOTAL', style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54
                                      )),
                                      Text(Utils.doubleToCurrency(cart.totalPrice),
                                          style: const TextStyle(
                                              fontSize: 27,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      SizedBox(
                        height: 680, width: 350,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return HistoryItemCard(item: items[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            else {
              return Center(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 70, color: Color.fromARGB(255, 96, 232, 142)),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 100),
                        child: Text('Algo deu errado. Não foi possível carregar o carrinho',
                          style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 96, 232, 142)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Material(
                        child: Ink(
                          padding: const EdgeInsets.all(8),
                          decoration: const ShapeDecoration(
                              color: Color.fromARGB(255, 96, 232, 142),
                              shape: CircleBorder()
                          ),
                          child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () { Navigator.pop(context); }
                          )
                        ),
                      )
                    ],
                  ),
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
