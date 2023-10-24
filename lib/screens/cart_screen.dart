import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:smartcart/screens/dialogs/cart_header_form.dart';
import 'package:smartcart/screens/dialogs/delete_cart_warning.dart';
import 'package:text_scroll/text_scroll.dart';
import '../components/cart_item.dart';
import '../data/current_cart.dart';
import 'dialogs/item_form.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final formKey = GlobalKey<FormState>();

  void refreshMe() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var currentCart = CurrentCart.of(context);
    currentCart.refreshCartScreen = refreshMe;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 232, 142),
        leading: BackButton(
          color: Colors.white,
          onPressed: () { 
            if (currentCart.items.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => const DeleteCartWarning()
              );
            }
            else {
              Navigator.pop(context);
            }
          },
        ),
        title: TextScroll(
          '${currentCart.cartName} - ${currentCart.marketName} - ${currentCart.date}       ',
          velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
          delayBefore: const Duration(seconds: 3),
          pauseBetween: const Duration(seconds: 5),
          style: const TextStyle(fontSize: 15, color: Colors.white)
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (newContext) => CartHeaderForm(cartContext: context)
                ).then((value) => setState((){}));
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
                  children: [
                    SizedBox(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(currentCart.cartItemQnty > 1 ?
                          '${currentCart.cartItemQnty} itens' :
                          currentCart.cartItemQnty > 0 ?
                          '1 item' : 'carrinho vazio',
                            style: const TextStyle(
                                fontSize: 15, fontWeight:
                                FontWeight.w400,
                                color: Colors.black38
                            )
                        ),
                      ),
                    ),
                    Material(
                      color: const Color.fromARGB(255, 96, 232, 142),
                      child: Ink(
                          padding: const EdgeInsets.all(5),
                          decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: CircleBorder()
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.shopping_cart_checkout, color: Color.fromARGB(255, 96, 232, 142)),
                            iconSize: 40,
                            onPressed: (){
                              if (currentCart.items.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Não há itens no carrinho'),
                                    behavior: SnackBarBehavior.floating,
                                  )
                                );
                              }
                              else {

                              }
                            },
                          )
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
                                color: Colors.black38
                            )),
                            Text('R\$ ${currentCart.formatCurrency(currentCart.cartPrice.toStringAsFixed(2))}',
                                style: const TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black38
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
              height: 545, width: 350,
              child: ListView.builder(
                itemCount: currentCart.items.length,
                itemBuilder: (context, index) {
                  return currentCart.items[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Column(
                children: [
                  // DottedBorder(
                  //   borderType: BorderType.RRect,
                  //   radius: const Radius.circular(8),
                  //   dashPattern: const [10, 8],
                  //   strokeWidth: 5,
                  //   child:
                  // ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Adicionar Item', style: TextStyle(color: Colors.grey)),
                ),
                Container(
                    height: 90, width: 250,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 96, 232, 142),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                color: const Color.fromARGB(255, 96, 232, 142),
                                child: Ink(
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Colors.white
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add_a_photo_rounded),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text('Foto da Etiqueta',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black45
                                    )
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                color: const Color.fromARGB(255, 96, 232, 142),
                                child: Ink(
                                  decoration: const ShapeDecoration(
                                      shape: CircleBorder(),
                                      color: Colors.white
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (newContext) => NewItemForm(cartContext: context)
                                      ).then((value) => { setState((){ print('rebuilding cart screen'); }) });
                                    },
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text('Manualmente',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black45
                                    )
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}
