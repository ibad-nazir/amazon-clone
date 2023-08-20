// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:ecomerceapp/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../constants/global_variable.dart';
import '../../../constants/http_error_handling.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import '../../../provider/user_provider.dart';

class AddressSevices {
  static Future<void> saveAddress({
    required BuildContext context,
    required String address,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      http.Response response =
          await http.post(Uri.parse('$uri/api/save-user-address'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': user.token,
              },
              body: jsonEncode({
                'address': address,
              }));

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Address Saved Scuccessfully');
          User user2 = user.copyWith(address: address);
          Provider.of<UserProvider>(context, listen: false)
              .setUserFromModel(user2);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // showSnackBar(context, e.toString());
    }
  }

  static void placeOrder({
    required BuildContext context,
    required String address,
    required double total,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/order'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          },
          body: jsonEncode({
            'address': address,
            'totalPrice': total,
            'cart': user.cart,
          }));

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order Placed Scuccessfully');
          User user2 = user.copyWith(cart: []);
          Provider.of<UserProvider>(context, listen: false)
              .setUserFromModel(user2);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // showSnackBar(context, e.toString());
    }
  }

  static void placeSingle({
    required BuildContext context,
    required String address,
    required Product product,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      print(address + product.id!);
      http.Response response = await http.post(Uri.parse('$uri/api/order-one'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          },
          body: jsonEncode({
            'address': address,
            'productId': product.id,
          }));

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order Placed Scuccessfully');
          // Navigator.pop(context);
          // productProvider.setProductNull();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
