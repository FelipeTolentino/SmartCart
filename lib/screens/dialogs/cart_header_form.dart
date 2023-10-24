import 'package:flutter/material.dart';

import '../../data/current_cart.dart';

class CartHeaderForm extends StatefulWidget {
  CartHeaderForm({required this.cartContext, super.key});

  final BuildContext cartContext;
  //final formKey = GlobalKey<FormState>();

  TextEditingController cartNameController = TextEditingController();
  TextEditingController marketNameController = TextEditingController();


  @override
  State<CartHeaderForm> createState() => _CartHeaderFormState();
}

class _CartHeaderFormState extends State<CartHeaderForm> {
  @override
  Widget build(BuildContext context) {
    var currentCart = CurrentCart.of(widget.cartContext);
    widget.cartNameController.text = currentCart.cartName;
    widget.marketNameController.text = currentCart.marketName;

    return Form(
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        backgroundColor: Colors.white,
        title: const Text('Informações', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        titlePadding: const EdgeInsets.all(15),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: widget.cartNameController,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none
                      ),
                      contentPadding: const EdgeInsets.only(left: 10),
                      hintText: currentCart.cartName,
                      fillColor: Colors.white70,
                      filled: true,
                      errorStyle: const TextStyle(color: Colors.red)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: widget.marketNameController,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: currentCart.marketName,
                        fillColor: Colors.white70,
                        filled: true,
                        errorStyle: const TextStyle(color: Colors.red)
                    ),
                  ),
                ),
              ),
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
                currentCart.cartName = widget.cartNameController.text;
                currentCart.marketName = widget.marketNameController.text;
                ScaffoldMessenger.of(widget.cartContext).showSnackBar(
                    const SnackBar(
                        content: Text('Informações alteradas!'),
                        behavior: SnackBarBehavior.floating
                    )
                );
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
