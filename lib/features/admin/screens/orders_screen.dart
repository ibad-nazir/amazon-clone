import 'package:ecomerceapp/Common/widgets/Loader.dart';
import 'package:ecomerceapp/features/admin/services/admin_services.dart';
import 'package:ecomerceapp/features/order_details/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order>? orders;
  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  void fetchOrders() async {
    orders = await AdminServices.getOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : orders!.isEmpty
            ? const Center(child: Text('Text No Order is Available'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: orders!.length,
                itemBuilder: (ctx, indx) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderDetailsScreen.routeName,
                        arguments: orders![indx],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            orders![indx].products[0].images[0],
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  orders![indx].products[0].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                'Placed On ${DateTime.fromMillisecondsSinceEpoch(orders![indx].orderedAt)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Total Amount ${orders![indx].totalPrice}',
                              ),
                              const Text(
                                'PAID ',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
  }
}
