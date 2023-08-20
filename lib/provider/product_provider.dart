import 'package:ecomerceapp/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  Product _product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0);

  Product get product => _product;
  void setUserFromModel(Product product) {
    _product = product;
  }

  void setProductNull() {
    _product = Product(
        name: '',
        description: '',
        quantity: 0,
        images: [],
        category: '',
        price: 0);
  }
}
