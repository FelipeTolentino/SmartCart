import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartcart/models/cart.dart';
import '../screens/popups/item_form.dart';
import '../utils/utils.dart';

class ItemCard extends StatefulWidget {
  ItemCard({
    required this.itemIndex,
    super.key
  });

  int itemIndex;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (BuildContext context, Cart cart, _) {
        return InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => ItemForm.edit(cart: cart, itemIndex: widget.itemIndex)
            ).then((confirmed) {
              if (confirmed) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item adicionado!'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.only(right: 20, left: 20, bottom: 90),
                    )
                );
              }
            });
          },
          child: Padding(
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
                      child: Text(cart.getItemName(widget.itemIndex),
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
                                    cart.decrementItemQnty(widget.itemIndex);
                                  }
                                ),
                                Text(cart.getItemQnty(widget.itemIndex).toString(),
                                    style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle,
                                    color: Color.fromARGB(255, 96, 232, 142),
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      cart.incrementItemQnty(widget.itemIndex);
                                    });
                                  }
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${cart.getItemQnty(widget.itemIndex)} x ${Utils.doubleToCurrency(cart.getItemPrice(widget.itemIndex))}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 67, 181, 105),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12
                                  )
                              ),
                              Text(Utils.doubleToCurrency(cart.getItemTotalPrice(widget.itemIndex)),
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
          ),
        );
      },
    );
  }
}
