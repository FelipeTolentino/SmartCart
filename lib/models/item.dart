class Item {
  String name = 'Novo Item';
  int quantity = 1;
  double price = 0;

  Item({
    required this.name,
    required this.quantity,
    required this.price
  });

  double totalPrice() {
    return quantity * price;
  }
}