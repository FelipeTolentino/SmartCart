import 'package:flutter/material.dart';
import 'package:smartcart/models/cart.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import '../../utils/utils.dart';

class ItemForm extends StatefulWidget {
  ItemForm({required this.cart, this.itemIndex, super.key});
  ItemForm.edit({required this.cart, required this.itemIndex, super.key}) {
    if (itemIndex != null) {
      itemNameController.text = cart.getItemName(itemIndex!);
      itemPriceController.text =
          Utils.doubleToCurrency(cart.getItemPrice(itemIndex!));
      itemQnty = cart.getItemQnty(itemIndex!);
    }
  }

  final Cart cart;
  final int? itemIndex;

  final formKey = GlobalKey<FormState>();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  int itemQnty = 1;

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: AlertDialog(
        title: Text(widget.itemIndex == null ? 'Novo Produto' : 'Alterar Produto', style: TextStyle(fontSize: 20)),
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
                        hintText: 'Nome',
                        fillColor: Colors.white70,
                        filled: true,
                        errorStyle: const TextStyle(color: Colors.red)
                    ),
                    validator: (String? input) {
                      return input != null && input.isEmpty ?
                      'Informe o nome do produto' : null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
                              print('teste');
                              widget.itemQnty - 1 > 0 ?
                              widget.itemQnty-- : widget.itemQnty = 1;
                            });
                          }
                      ),
                      Text(widget.itemQnty.toString(),
                          style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500)
                      ),
                      IconButton(
                          icon: const Icon(Icons.add_circle,
                            color: Color.fromARGB(255, 96, 232, 142),
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() { widget.itemQnty++; });
                          }
                      ),
                    ]
                ),
              )
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          Ink(
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: Color.fromARGB(255, 96, 232, 142)
            ),
            child: IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              iconSize: 40,
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  if (widget.itemIndex != null) {
                    widget.cart.editItem(
                        widget.itemIndex!,
                        widget.itemNameController.text,
                        Utils.currencyToDouble(widget.itemPriceController.text),
                        widget.itemQnty
                    );
                  }
                  else {
                    widget.cart.addItem(
                      name: widget.itemNameController.text,
                      price: Utils.currencyToDouble(widget.itemPriceController.text),
                      quantity: widget.itemQnty,
                    );
                  }
                  Navigator.pop(context, true);
                }
              },
            ),
          ),
          Ink(
            decoration: const ShapeDecoration(
                shape: CircleBorder(),
                color: Color.fromARGB(255, 96, 232, 142)
            ),
            child: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white),
              iconSize: 40,
              onPressed: (){
                Navigator.pop(context, false);
              },
            ),
          )
        ],
      ),
    );
  }
}
