import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  String title;
  String message;

  ConfirmDialog({required this.title, required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 20)),
      titlePadding: const EdgeInsets.all(15),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      content: SizedBox(
          width: 400,
          child: Text(message)
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
              Navigator.pop(context, true);
            },
          ),
        ),
      ],
    );
  }
}
