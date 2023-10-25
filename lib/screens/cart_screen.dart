import 'package:flutter/material.dart';
import 'package:smartcart/screens/dialogs/cart_header_form.dart';
import 'package:smartcart/screens/dialogs/delete_cart_warning.dart';
import 'package:text_scroll/text_scroll.dart';
import '../data/DAO_cart.dart';
import '../data/current_shared.dart';
import '../utils/utils.dart';
import 'dialogs/item_form.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({required this.homeContext, super.key});

  final BuildContext homeContext;

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
    var shared = CurrentShared.of(context);
    shared.refreshCartScreen = refreshMe;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 232, 142),
        leading: BackButton(
          color: Colors.white,
          onPressed: () { 
            if (shared.cart.items.isNotEmpty) {
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
          '${shared.cart.description} - ${shared.cart.market} - ${shared.cart.date}       ',
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
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.shopping_basket, size: 35, color: Colors.black54),
                            ),
                            Text(shared.cart.itemQuantity > 1 ?
                              '${shared.cart.itemQuantity} itens' :
                              shared.cart.itemQuantity > 0 ?
                              '1 item' : 'Vazio',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight:
                                    FontWeight.w400,
                                    color: Colors.black54
                                )
                            ),
                          ],
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
                          onPressed: () async {
                            if (shared.cart.items.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Não há itens no carrinho'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                )
                              );
                            }
                            else {
                              var result = await DAOCart().save(shared.cart);
                              if (result == 0) {
                                ScaffoldMessenger.of(widget.homeContext).showSnackBar(
                                  const SnackBar(content: Text('Carrinho salvo!'), behavior: SnackBarBehavior.floating)
                                );
                              }
                              else {
                                ScaffoldMessenger.of(widget.homeContext).showSnackBar(
                                  const SnackBar(
                                    content: Text('Desculpe! Algum erro ocorreu...'),
                                    behavior: SnackBarBehavior.floating
                                  )
                                );
                              }
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
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
                            Text(Utils.doubleToCurrency(shared.cart.totalPrice),
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
                itemCount: shared.cart.items.length,
                itemBuilder: (context, index) {
                  return shared.cart.items[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Column(
                children: [
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
                                    icon: Icon(Icons.add_a_photo_rounded, color: Colors.black12),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Desculpe! Essa opção ainda não está em funcionamento'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 5),
                                            margin: EdgeInsets.only(left: 20, right: 20, bottom: 100),
                                        )
                                      );
                                    },
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
                                      ).then((value) => { setState((){ }) });
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
