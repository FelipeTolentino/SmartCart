import 'package:flutter/material.dart';
import '../data/current_cart.dart';

class CartItem extends StatefulWidget {
  CartItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.cartContext,
    super.key
  });

  BuildContext cartContext;
  String name;
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
    var currentCart = CurrentCart.of(widget.cartContext);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        // color: Colors.black,
          height: 120,
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
                child: Text(widget.name!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('unidades', style: TextStyle(fontWeight: FontWeight.w200)),
                      Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle,
                                color: Color.fromARGB(255, 96, 232, 142),
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (widget.quantity - 1 > 0) {
                                    widget.quantity--;
                                  }
                                  else {
                                    currentCart.items.remove(widget.thisItem());
                                  }
                                  currentCart.updateCart();
                                  currentCart.refreshCartScreen!();
                                });
                              }
                          ),
                          Text(widget.quantity!.toString(),
                              style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
                          ),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                color: Color.fromARGB(255, 96, 232, 142),
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.quantity++;
                                  currentCart.updateCart();
                                  currentCart.refreshCartScreen!();
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
                        Text('${widget.quantity!} x R\$ ${currentCart.formatCurrency(widget.price.toStringAsFixed(2))}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 67, 181, 105),
                                fontWeight: FontWeight.w600
                            )
                        ),
                        Text('R\$ ${currentCart.formatCurrency(widget.itemTotalPrice().toStringAsFixed(2))}',
                            style: const TextStyle(
                                fontSize: 35,
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
