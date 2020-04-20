import 'dart:convert';
import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getLatestOrders() async {

    final url = 'https://shoppingcart-56fe6.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedData = [];
    final data = json.decode(response.body) as Map<String, dynamic>;
    if(data == null){
      return;
    }
    data.forEach((key, item) {
      loadedData.add(OrderItem(
          id: key,
          amount: item['amount'],
          dateTime: DateTime.parse(item['dateTime']),
          products: (item['products'] as List<dynamic>)
              .map((prd) => CartItem(
                    id: prd['id'],
                    price: prd['price'],
                    quantity: prd['quantity'],
                    title: prd['title'],
                  ))
              .toList()));
    });
    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = 'https://shoppingcart-56fe6.firebaseio.com/orders.json';
    final dateTime = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': dateTime.toIso8601String(),
          'products': products
              .map((prd) => {
                    'title': prd.title,
                    'price': prd.price,
                    'quantity': prd.quantity
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: products,
        dateTime: dateTime,
      ),
    );
    notifyListeners();
  }
}
