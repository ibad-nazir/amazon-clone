// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecomerceapp/constants/global_variable.dart';
import 'package:ecomerceapp/constants/utils.dart';
import 'package:ecomerceapp/models/order.dart';
import 'package:ecomerceapp/models/product.dart';
import 'package:ecomerceapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../constants/http_error_handling.dart';
import '../model/sales.dart';
// import '../../../models/order.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final cloudinary = CloudinaryPublic('diwz8hrnl', 'e6c2xu7w');
      List<String> urls = [];
      for (var i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        urls.add(res.secureUrl.toString());
      }
      Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: urls,
          category: category,
          price: price);
      final response = await http.post(Uri.parse('$uri/admin/add-product'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          },
          body: product.toJson());
      // print(response.body);
      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Added Scuccessfully');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  static Future<List<Product>> showProducts({
    required BuildContext context,
  }) async {
    List<Product> products = [];
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse('$uri/admin/get-products'),
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

  static void deleteProduct(
    Product product,
    BuildContext context, {
    required VoidCallback function,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final response = await http.delete(
      Uri.parse('$uri/admin/delete-product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': user.token,
      },
      body: jsonEncode(<String, String>{
        'id': product.id!,
      }),
    );
    httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          function();
          showSnackBar(context, 'Product Deleted Successfully');
        });
  }

  static Future<List<Order>> getOrders({
    required BuildContext context,
  }) async {
    List<Order> orders = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      // print(response.body);
      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              orders.add(
                  Order.fromJson(jsonEncode(jsonDecode(response.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orders;
  }

  static void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
