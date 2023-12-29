import 'package:flutter/material.dart';
import 'package:smartcart/components/history_cart_item.dart';
import 'package:text_scroll/text_scroll.dart';
import '../data/DAO_cart.dart';
import '../data/current_shared.dart';
import '../utils/utils.dart';
import './dialogs/confirm_dialog.dart';

class HistoryCartScreen extends StatefulWidget {
  const HistoryCartScreen({required this.cartID, super.key});

  final int cartID;

  @override
  State<HistoryCartScreen> createState() => _HistoryCartScreenState();
}

class _HistoryCartScreenState extends State<HistoryCartScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Cart>(
        future: DAOCart().findThis(widget.cartID, context),
        builder: (context, snapshot) {
          Cart? cart = snapshot.data;
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
              if (!snapshot.hasData || cart == null) {
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
              else {
                List<HistoryCartItem> items = cart.convertToHistoryItems();
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
                              var result = await DAOCart().deleteThis(widget.cartID);
                              if (result > 0) Navigator.pop(context);
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Um erro ocorreu!'),
                                      behavior: SnackBarBehavior.floating,
                                    )
                                );
                              }
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
                              return items[index];
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          }
        }
    );
  }
}
