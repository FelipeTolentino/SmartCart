import 'package:flutter/material.dart';
import '../data/current_shared.dart';
import '../utils/utils.dart';

class CartItem extends StatefulWidget {
  CartItem({
    required this.description,
    required this.quantity,
    required this.price,
    required this.cartContext,
    super.key
  });

  BuildContext cartContext;
  String description;
  int quantity;
  double price;

  double itemTotalPrice() {
    return quantity * price;
  }

  CartItem thisItem() {
    return this;
  }

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    var shared = CurrentShared.of(widget.cartContext);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        // color: Colors.black,
          height: 100,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 235, 235, 235),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.description!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('unidades', style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 10
                      )),
                      Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle,
                                color: Color.fromARGB(255, 96, 232, 142),
                                size: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (widget.quantity - 1 > 0) {
                                    widget.quantity--;
                                  }
                                  else {
                                    shared.cart.items.remove(widget.thisItem());
                                  }
                                  shared.cart.updateCart();
                                  shared.refreshCartScreen!();
                                });
                              }
                          ),
                          Text(widget.quantity!.toString(),
                              style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)
                          ),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                color: Color.fromARGB(255, 96, 232, 142),
                                size: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.quantity++;
                                  shared.cart.updateCart();
                                  shared.refreshCartScreen!();
                                });
                              }
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${widget.quantity!} x ${Utils.doubleToCurrency(widget.price)}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 67, 181, 105),
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            )
                        ),
                        Text(Utils.doubleToCurrency(widget.itemTotalPrice()),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
