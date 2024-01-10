import 'package:flutter/material.dart';
import 'package:smartcart/models/item.dart';
import '../utils/utils.dart';

class HistoryItemCard extends StatefulWidget {
  const HistoryItemCard({required this.item, super.key});

  final Item item;

  HistoryItemCard thisItem() {
    return this;
  }

  @override
  State<HistoryItemCard> createState() => _HistoryItemCardState();
}

class _HistoryItemCardState extends State<HistoryItemCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        // color: Colors.black,
          height: 83,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 235, 235, 235),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.item.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${widget.item.quantity} x ${Utils.doubleToCurrency(widget.item.price)}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 67, 181, 105),
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            )
                        ),
                        Text(Utils.doubleToCurrency(widget.item.totalPrice()),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
