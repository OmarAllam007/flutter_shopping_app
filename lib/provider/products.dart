import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favouriteItems {
    return products.where((product) => product.isFavourite == true).toList();
  }

  Product show(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> index() async {
    final url = 'https://shoppingcart-56fe6.firebaseio.com/products_list.json';

    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      List<Product> loadedProducts = [];

      data.forEach((key, item) {
        loadedProducts.add(Product(
          id: key,
          title: item['title'],
          description: item['description'],
          imageUrl: item['imageUrl'],
          price: item['price'],
          isFavourite: item['isFavourite'],
        ));
      });

      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> store(Product product) async {
    final url = 'https://shoppingcart-56fe6.firebaseio.com/products_list.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavourite': product.isFavourite,
          'price': product.price,
          'id': DateTime.now().toString()
        }),
      );
      _products.add(
        Product(
            id: json.decode(response.body)['name'],
            title: product.title,
            description: product.description,
            imageUrl: product.imageUrl,
            price: product.price),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> update(Product newProduct) async {
    final index = _products.indexWhere((prod) => prod.id == newProduct.id);

    if (index >= 0) {
      final url =
          'https://shoppingcart-56fe6.firebaseio.com/products_list/${newProduct.id}.json';

      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'isFavourite': newProduct.isFavourite,
            'price': newProduct.price,
          }));

      _products[index] = newProduct;
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    final existProductIndex =
        _products.indexWhere((product) => product.id == id);
    var existProduct = _products[existProductIndex];
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
    final url =
        'https://shoppingcart-56fe6.firebaseio.com/products_list/${id}.json';

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _products.insert(existProductIndex, existProduct);
      notifyListeners();
      throw HttpException("Deleting not completed");
    }
    existProduct = null;
  }
}
