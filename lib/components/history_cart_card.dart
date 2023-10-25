import 'package:flutter/material.dart';
import 'package:smartcart/screens/history_cart_screen.dart';

import '../data/DAO_cart.dart';
import '../utils/utils.dart';

class HistoryCartCard extends StatelessWidget {
  HistoryCartCard({
    required this.id,
    required this.description,
    required this.market,
    required this.date,
    required this.itemQuantity,
    required this.price,
    super.key,
  });
  
  int id;
  String description;
  String market;
  String date;
  int itemQuantity;
  double price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       Navigator.push(context, MaterialPageRoute(
           builder: (context) =>  HistoryCartScreen(cartID: id)
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
                child: Text(description,
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
                              Text(market)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(date),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(itemQuantity > 1 ? '${itemQuantity.toString()} itens' : '${itemQuantity.toString()} item'),
                        Text(Utils.doubleToCurrency(price), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500))
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
}

