import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartcart/components/i_text_recognizer.dart';
import 'package:smartcart/components/text_recognizer.dart';
import 'package:smartcart/screens/dialogs/cart_header_form.dart';
import 'package:smartcart/screens/dialogs/delete_cart_warning.dart';
import 'package:text_scroll/text_scroll.dart';
import '../data/DAO_cart.dart';
import '../data/current_shared.dart';
import '../utils/utils.dart';
import 'dialogs/item_form.dart';

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
  const CartScreen({required this.homeContext, super.key});

  final BuildContext homeContext;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final formKey = GlobalKey<FormState>();
  late ImagePicker picker = ImagePicker();
  late ITextRecognizer recognizer = MLKitTextRecognizer();
  var insertMethod = InsertItemMethod();

  Future<String?> obtainImage(ImageSource source) async {
      final file = await picker.pickImage(source: source);
      return file?.path;
  }

  void refreshMe() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (recognizer is MLKitTextRecognizer) {
      (recognizer as MLKitTextRecognizer).dispose();
    }
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
                    GestureDetector(
                      onLongPress: () {
                        insertMethod.changeMethod();
                        setState(() {});
                      },
                      onTap: () async {
                        if (insertMethod.method == InsertMethod.MANUALLY) {
                          showDialog(
                              context: context,
                              builder: (newContext) => NewItemForm(cartContext: context)
                          ).then((value) => { setState((){ }) });
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
              height: 600, width: 350,
              child: ListView.builder(
                itemCount: shared.cart.items.length,
                itemBuilder: (context, index) {
                  return shared.cart.items[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Ink(
                decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Color.fromARGB(255, 96, 232, 142),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                  iconSize: 50,
                  onPressed: () async {
                    if (shared.cart.items.isEmpty) {
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
                      var checkout = false;
                      showDialog(
                          context: context,
                          builder: (newContext) => AlertDialog(
                            title: const Text('Finaliando Carrinho', style: TextStyle(fontSize: 20)),
                            titlePadding: const EdgeInsets.all(15),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            backgroundColor: Colors.white,
                            contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                            content: const SizedBox(
                              width: 400,
                              child: Text("Tem certeza que deseja finalizar este carrinho?")
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              Ink(
                                decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Color.fromARGB(255, 96, 232, 142)
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.check, color: Colors.white),
                                  iconSize: 40,
                                  onPressed: (){
                                    checkout = true;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          )
                      ).then( (value) async {
                        if (checkout) {
                          var result = await DAOCart().save(shared.cart);
                          if (result == 0) {
                            ScaffoldMessenger.of(widget.homeContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Carrinho salvo!'),
                                  behavior: SnackBarBehavior.floating,
                                )
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
                      });
                    }
                  },
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}
