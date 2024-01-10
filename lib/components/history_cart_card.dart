import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartcart/models/cart.dart';
import 'package:smartcart/models/history.dart';
import 'package:smartcart/screens/history_cart_screen.dart';
import '../utils/utils.dart';

class HistoryCartCard extends StatelessWidget {
  HistoryCartCard({required this.cartIndex, super.key});

  final int cartIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<History>(
      builder: (BuildContext consumerContext, History history, _) {
        Cart? cart = history.getCart(cartIndex);
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (newContext) => HistoryCartScreen(history: history, cartIndex: cartIndex)
            ));
          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 235, 235),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 15),
                          child: Text(cart.description,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color.fromARGB(255, 67, 181, 105)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3, bottom: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.store),
                                        Text(cart.market)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(cart.date),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(cart.itemQuantity > 1 ? '${cart.itemQuantity.toString()} itens' : '${cart.itemQuantity.toString()} item'),
                                  Text(Utils.doubleToCurrency(cart.totalPrice), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500))
                                ],
                              )
                            ],
                          ),
                        )
                      ]
                  )
              )
          ),
        );
      }
    );
  }
}

