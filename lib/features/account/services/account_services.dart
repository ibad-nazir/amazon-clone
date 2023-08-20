// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ecomerceapp/features/auth/screens/login_screen.dart';
import 'package:ecomerceapp/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/global_variable.dart';
import '../../../constants/http_error_handling.dart';
import 'package:http/http.dart' as http;

import '../../../constants/utils.dart';
import '../../../provider/user_provider.dart';

class AccountServices {
  static Future<List<Order>> getOrderDetails(
    BuildContext context,
  ) async {
    List<Order> orders = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          for (var i = 0; i < jsonDecode(res.body).length; i++) {
            Order order = Order.fromJson(jsonEncode(jsonDecode(res.body)[i]));
            orders.add(order);
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orders;
  }

  static void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
