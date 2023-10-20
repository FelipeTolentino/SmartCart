import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../components/cart_item.dart';
import '../data/current_cart.dart';
import 'dialogs/new_item_dialog.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

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
          onPressed: () { Navigator.pop(context); },
        ),
        title: Text('${currentCart.cartName} - ${currentCart.marketName} - ${currentCart.date}'),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {}
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
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
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
                            iconSize: 50,
                            onPressed: (){},
                          )
                      ),
                    ),
                    SizedBox(
                      width: 165,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('TOTAL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                            Text('R\$ ${currentCart.formatCurrency(currentCart.cartPrice.toStringAsFixed(2))}',
                                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
            SizedBox(
              height: 470, width: 350,
              child: ListView.builder(
                itemCount: currentCart.items.length,
                itemBuilder: (context, index) {
                  return currentCart.items[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: Column(
                children: [
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    dashPattern: const [10, 8],
                    strokeWidth: 5,
                    child: Container(
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
                                  child: Text('Foto da Etiqueta', style: TextStyle(fontSize: 10)),
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
                                            builder: (newContext) => NewItemDialog(cartContext: context)
                                        ).then((value) => { setState((){ print('rebuilding cart screen'); }) });
                                      },
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text('Manualmente', style: TextStyle(fontSize: 10)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Adicionar Item'),
                  )
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}
