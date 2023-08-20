import 'package:ecomerceapp/Common/widgets/Loader.dart';
import 'package:ecomerceapp/constants/global_variable.dart';
import 'package:ecomerceapp/features/account/services/account_services.dart';
import 'package:ecomerceapp/features/account/widgets/single_product.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';
import '../../order_details/screens/order_details_screen.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    orders = await AccountServices.getOrderDetails(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 25),
                    child: const Text(
                      'Your Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: GlobalVariables.selectedNavBarColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              orders!.isEmpty
                  ? const Text('No Orders')
                  : Container(
                      height: 170,
                      padding:
                          const EdgeInsets.only(left: 10, top: 20, right: 0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: orders!.length,
                        itemBuilder: (ctx, idx) => InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, OrderDetailsScreen.routeName,
                                arguments: orders![idx]);
                          },
                          child: SingleProduct(
                            image: orders![idx].products[0].images[0],
                          ),
                        ),
                      ),
                    ),
            ],
          );
  }
}
