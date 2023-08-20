// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variable.dart';
import '../../../constants/http_error_handling.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';
import '../../../provider/user_provider.dart';
import 'package:http/http.dart' as http;

class SearchServices {
  static Future<List<Product>> searchProducts({
    required BuildContext context,
    required String query,
  }) async {
    List<Product> products = [];
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse('$uri/api/products/search/$query'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
      );
      // print(response.body);
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
}
