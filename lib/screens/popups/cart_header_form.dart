import 'package:flutter/material.dart';
import '../../models/cart.dart';

class CartHeaderForm extends StatefulWidget {
  CartHeaderForm({required this.cart, super.key});

  TextEditingController cartDescriptionController = TextEditingController();
  TextEditingController marketNameController = TextEditingController();

  Cart cart;

  @override
  State<CartHeaderForm> createState() => _CartHeaderFormState();
}

class _CartHeaderFormState extends State<CartHeaderForm> {
  @override
  Widget build(BuildContext context) {
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
                    controller: widget.cartDescriptionController,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: widget.cart.description,
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
                        hintText: widget.cart.market,
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
                widget.cart.setDescription(widget.cartDescriptionController.text);
                widget.cart.setMarket(widget.marketNameController.text);
                Navigator.pop(context, true);
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
