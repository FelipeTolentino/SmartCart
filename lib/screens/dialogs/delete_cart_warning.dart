import 'package:flutter/material.dart';

class DeleteCartWarning extends StatelessWidget {
  const DeleteCartWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        backgroundColor: Colors.white,
        title: const Text('Atenção!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        content: const Text('Ao retornar desta tela os itens do carrinho serão perdidos!'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          Ink(
            decoration: const ShapeDecoration(
                shape: CircleBorder(),
                color: Color.fromARGB(255, 96, 232, 142)
            ),
            child: IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              iconSize: 35,
              onPressed: (){
                int count = 2;
                Navigator.popUntil(context, (_) => count-- <= 0);
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
              iconSize: 35,
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          )
        ]
    );
  }
}
