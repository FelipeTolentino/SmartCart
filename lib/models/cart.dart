import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/DAO_cart.dart';
import './item.dart';

class Cart extends ChangeNotifier {
  int id = -1;
  String description = 'Novo Carrinho';
  String market = 'Mercado';
  String date = '99/99/9999';
  List<Item> items = [];
  int itemQuantity = 0;
  double totalPrice = 0;

  Cart() {
    date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Cart.header({required this.description, required this.market, required this.date});
  Cart.description({required this.description});
  Cart.history({
    required this.id,
    required this.description,
    required this.market,
    required this.date,
    required this.itemQuantity,
    required this.totalPrice
  });

  void setDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  void setMarket(String newMarket) {
    market = newMarket;
    notifyListeners();
  }

  void updateTotalPrice() {
    totalPrice = 0;
    for (var item in items) {
      totalPrice += item.totalPrice();
    }
  }

  void updateItemQnty() {
    itemQuantity = 0;
    for (var item in items) {
      itemQuantity += item.quantity;
    }
  }

  void addItem({required String name, required double price, required int quantity}) {
    items.add(Item(name: name, price: price, quantity: quantity));
    updateItemQnty();
    updateTotalPrice();
    notifyListeners();
  }

  void setItems({required List<Item> items}) {
    this.items = items;
  }

  void removeItem(int itemIndex) {
    items.removeAt(itemIndex);
    updateItemQnty();
    updateTotalPrice();
    notifyListeners();
  }

  void decrementItemQnty(int itemIndex) {
    if (items[itemIndex].quantity - 1 > 0) {
      items[itemIndex].quantity--;
      updateItemQnty();
      updateTotalPrice();
      notifyListeners();
    }
    else {
      removeItem(itemIndex);
    }
  }

  void incrementItemQnty(int itemIndex) {
    items[itemIndex].quantity++;
    updateItemQnty();
    updateTotalPrice();
    notifyListeners();
  }

  void editItem(int itemIndex, String name, double price, int quantity) {
    items[itemIndex].name = name;
    items[itemIndex].price = price;
    items[itemIndex].quantity = quantity;
    updateItemQnty();
    updateTotalPrice();
    notifyListeners();
  }

  String getItemName(int itemIndex) {
    return items[itemIndex].name;
  }

  int getItemQnty(int itemIndex) {
    return items[itemIndex].quantity;
  }

  double getItemPrice(int itemIndex) {
    return items[itemIndex].price;
  }

  double getItemTotalPrice(int itemIndex) {
    return items[itemIndex].totalPrice();
  }

  Future<List<Item>> queryItems() async {
    return await DAOCart().getCartItems(id);
  }
}