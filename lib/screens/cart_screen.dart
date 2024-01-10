import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartcart/components/i_text_recognizer.dart';
import 'package:smartcart/components/text_recognizer.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:smartcart/screens/popups/confirm_dialog.dart';
import 'package:smartcart/screens/popups/cart_header_form.dart';
import 'package:smartcart/screens/popups/item_form.dart';
import 'package:smartcart/components/item_card.dart';
import '../data/DAO_cart.dart';
import '../utils/utils.dart';
import '../models/cart.dart';

enum InsertMethod {
  MANUALLY,
  PHOTO
}

class InsertItemMethod {
  InsertMethod method = InsertMethod.MANUALLY;
  IconData icon = Icons.edit;

  void changeMethod () {
    method = method == InsertMethod.MANUALLY ? InsertMethod.PHOTO : InsertMethod.MANUALLY;
    icon = icon == Icons.edit ? Icons.add_a_photo_rounded : Icons.edit;
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final formKey = GlobalKey<FormState>();

  late ImagePicker picker = ImagePicker();
  late ITextRecognizer recognizer = MLKitTextRecognizer();

  Future<String?> obtainImage(ImageSource source) async {
      final file = await picker.pickImage(source: source);
      return file?.path;
  }

  var insertMethod = InsertItemMethod();

  @override
  void dispose() {
    super.dispose();
    if (recognizer is MLKitTextRecognizer) {
      (recognizer as MLKitTextRecognizer).dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 232, 142),
        leading: Consumer<Cart>(
          builder: (BuildContext newContext, Cart cart, _) {
            return BackButton(
              color: Colors.white,
              onPressed: () {
                if (cart.items.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                          title: 'Atenção!',
                          message: 'Ao retornar desta tela os itens do carrinho serão perdidos'
                      )
                  ).then((confirmed) {
                    if (confirmed) Navigator.pop(context);
                  });
                }
                else {
                  Navigator.pop(context);
                }
              },
            );
          }
        ),
        title: Consumer<Cart>(
          builder: (BuildContext newContext, Cart cart, _) {
            return TextScroll(
                '${cart.description} - ${cart.market} - ${cart.date}       ',
                velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                delayBefore: const Duration(seconds: 3),
                pauseBetween: const Duration(seconds: 5),
                style: const TextStyle(fontSize: 15, color: Colors.white)
            );
          }
        ),
        actions: [
          Consumer<Cart>(
            builder: (BuildContext content, Cart cart, _) {
              return IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (newContext) => CartHeaderForm(cart: cart)
                    ).then((confirmed) {
                      if (confirmed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Informações alteradas!'),
                                behavior: SnackBarBehavior.floating
                            )
                        );
                      }
                    });
                  }
              );
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
                            Consumer<Cart>(
                              builder: (BuildContext context, Cart cart, _) {
                                return Text(cart.itemQuantity > 1 ?
                                '${cart.itemQuantity} itens' :
                                cart.itemQuantity > 0 ?
                                '1 item' : 'Vazio',
                                    style: const TextStyle(
                                        fontSize: 15, fontWeight:
                                    FontWeight.w400,
                                        color: Colors.black54
                                    )
                                );
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                    Consumer<Cart>(
                      builder: (BuildContext context, Cart cart, _) {
                        return GestureDetector(
                          onLongPress: () {
                            insertMethod.changeMethod();
                            setState(() {});
                          },
                          onTap: () async {
                            if (insertMethod.method == InsertMethod.MANUALLY) {
                              showDialog(
                                  context: context,
                                  builder: (context) => ItemForm(cart: cart)
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
                            }
                            else {
                              final imgPath = await obtainImage(ImageSource.gallery);
                              print('TEXT: ${await recognizer.processImage(imgPath!)}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Desculpe! Essa opção ainda não está em funcionamento'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 5),
                                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 100),
                                  )
                              );
                            }
                          },
                          child: Material(
                            color: const Color.fromARGB(255, 96, 232, 142),
                            child: Ink(
                              padding: const EdgeInsets.all(8),
                              decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(),
                              ),
                              child: Icon(
                                  insertMethod.icon,
                                  color: const Color.fromARGB(255, 96, 232, 142),
                                  size: 40
                              ),
                            ),
                          ),
                        );
                      }
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
                            Consumer<Cart>(
                              builder: (BuildContext newContext, Cart cart, _) {
                                return Text(Utils.doubleToCurrency(cart.totalPrice),
                                  style: const TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black38
                                  )
                                );
                              }
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
            SizedBox(
              height: 600, width: 350,
              child: Consumer<Cart>(
                builder: (BuildContext newContext, Cart cart, _) {
                  return ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return ItemCard(itemIndex: index);
                    },
                  );
                }
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Ink(
                decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Color.fromARGB(255, 96, 232, 142),
                ),
                child: Consumer<Cart>(
                  builder: (BuildContext newContext, Cart cart, _) {
                    return IconButton(
                      icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                      iconSize: 50,
                      onPressed: () async {
                        if (cart.items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Não há itens no carrinho!'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 100),
                              )
                          );
                        }
                        else {
                          showDialog(
                              context: context,
                              builder: (newContext) => ConfirmDialog(
                                  title: "Finalizando Carrinho",
                                  message: "Tem certeza que deseja finalizar o carrinho?"
                              )
                          ).then((confirmed) async {
                            if (confirmed) {
                              var result = await DAOCart().saveCart(cart);
                              if (result == 0) Navigator.pop(context, true);
                              else Navigator.pop(context, false);
                            }
                          });
                        }
                      },
                    );
                  }
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}
