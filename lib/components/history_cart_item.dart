import 'package:flutter/material.dart';
import '../data/current_shared.dart';
import '../utils/utils.dart';

class HistoryCartItem extends StatefulWidget {
  HistoryCartItem({
    required this.description,
    required this.quantity,
    required this.price,
    super.key
  });

  String description;
  int quantity;
  double price;

  double itemTotalPrice() {
    return quantity * price;
  }

  HistoryCartItem thisItem() {
    return this;
  }

  @override
  State<HistoryCartItem> createState() => _HistoryCartItemState();
}

class _HistoryCartItemState extends State<HistoryCartItem> {
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
                child: Text(widget.description!,
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
                        Text('${widget.quantity} x ${Utils.doubleToCurrency(widget.price)}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 67, 181, 105),
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            )
                        ),
                        Text(Utils.doubleToCurrency(widget.itemTotalPrice()),
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
