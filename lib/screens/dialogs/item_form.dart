import 'package:flutter/material.dart';
import 'package:smartcart/data/current_shared.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../utils/utils.dart';

class NewItemForm extends StatefulWidget {
  NewItemForm({required this.cartContext, super.key});

  final formKey = GlobalKey<FormState>();
  final BuildContext cartContext;

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  int newItemQnty = 1;

  @override
  State<NewItemForm> createState() => _NewItemFormState();
}

class _NewItemFormState extends State<NewItemForm> {
  @override
  Widget build(BuildContext context) {
    var shared = CurrentShared.of(widget.cartContext);

    return Form(
      key: widget.formKey,
      child: AlertDialog(
        title: const Text('Novo Produto', style: TextStyle(fontSize: 20)),
        titlePadding: const EdgeInsets.all(15),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: widget.itemNameController,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: 'Descrição',
                        fillColor: Colors.white70,
                        filled: true,
                        errorStyle: const TextStyle(color: Colors.red)
                    ),
                    validator: (String? input) {
                      return input != null && input.isEmpty ?
                      'Informe uma descrição para o produto' : null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          controller: widget.itemPriceController,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            contentPadding: const EdgeInsets.only(left: 10),
                              hintText: 'R\$ 0.00',
                              fillColor: Colors.white70,
                              filled: true,
                              errorStyle: const TextStyle(color: Colors.red),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              locale: 'pt_BR',
                              decimalDigits: 2,
                              symbol: 'R\$'
                            )
                          ],
                          validator: (String? input) {
                            return input != null && input.isEmpty ?
                                'Informe o valor do produto (un)' : null;
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('un', style: TextStyle(color: Colors.black38)),
                      ),
                      IconButton(
                          icon: const Icon(Icons.remove_circle,
                            color: Color.fromARGB(255, 96, 232, 142),
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.newItemQnty - 1 > 0 ?
                              widget.newItemQnty-- : widget.newItemQnty = 1;
                            });
                          }
                      ),
                      Text(widget.newItemQnty.toString(),
                          style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500)
                      ),
                      IconButton(
                          icon: const Icon(Icons.add_circle,
                            color: Color.fromARGB(255, 96, 232, 142),
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() { widget.newItemQnty++; });
                          }
                      ),
                    ]
                ),
              )
            ],
          ),
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
                if (widget.formKey.currentState!.validate()) {
                  shared.cart.addItem(
                    description: widget.itemNameController.text,
                    price: Utils.currencyToDouble(widget.itemPriceController.text),
                    quantity: widget.newItemQnty,
                    cartContext: widget.cartContext
                  );
                  shared.cart.updateCart();
                  ScaffoldMessenger.of(widget.cartContext).showSnackBar(
                    const SnackBar(
                      content: Text('Item adicionado!'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.only(right: 20, left: 20, bottom: 90),
                    )
                  );
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
