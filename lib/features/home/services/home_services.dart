// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variable.dart';
import '../../../constants/http_error_handling.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';
import '../../../provider/user_provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  static Future<List<Product>> showProducts({
    required BuildContext context,
    required String category,
  }) async {
    List<Product> products = [];
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
      );
      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              products.add(
                  Product.fromJson(jsonEncode(jsonDecode(response.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return products;
  }

  static Future<Product> getProductofDay(
    BuildContext context,
  ) async {
    Product product = Product(
      category: '',
      description: '',
      images: [],
      name: '',
      price: 0,
      quantity: 0,
    );
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      http.Response response = await http.get(
        Uri.parse('$uri/api/deal-of-day'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
      );
      // print(response.body);
      product = Product.fromJson(jsonEncode(jsonDecode(response.body)));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return product;
  }
}
