import 'package:ecomerceapp/features/admin/services/admin_services.dart';
import 'package:ecomerceapp/features/order_details/widgets/single_product_widget.dart';
import 'package:ecomerceapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Common/widgets/custom_buttom.dart';
import '../../../constants/global_variable.dart';
import '../../../models/order.dart';
import '../../search/screens/search_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = "route\\OrderDetailsScreen";
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentStep = 0;
  void onFieldSubmitted(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    currentStep = widget.order.status;
    super.initState();
  }

  void changeOrderStatus(int status) {
    AdminServices.changeOrderStatus(
      context: context,
      status: status + 1,
      order: widget.order,
      onSuccess: () {
        setState(() {
          currentStep += 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(
                    left: 15,
                  ),
                  alignment: Alignment.topLeft,
                  child: Material(
                    borderRadius: BorderRadius.circular(
                      7,
                    ),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: onFieldSubmitted,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(Icons.search),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(
                          top: 10,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search web-n-codes',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.order.id),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                // alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Placed On       ${DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt)}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Price Paid       \$${widget.order.totalPrice}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Address          ${widget.order.address}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < widget.order.products.length; i++)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleOrderProduct(product: widget.order.products[i]),
                ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.black12,
                margin: const EdgeInsets.all(10),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Stepper(
                    physics: const NeverScrollableScrollPhysics(),
                    currentStep: currentStep,
                    controlsBuilder: (context, details) {
                      if (user.type == 'admin' && currentStep < 3) {
                        return CustomButton(
                          text: 'Done',
                          onTap: () => changeOrderStatus(details.currentStep),
                        );
                      }
                      return const SizedBox();
                    },
                    steps: [
                      Step(
                        title: const Text('Pending'),
                        content: const Text(
                          'Your order is yet to be delivered',
                        ),
                        isActive: currentStep > 0,
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Completed'),
                        content: const Text(
                          'Your order has been delivered, you are yet to sign.',
                        ),
                        isActive: currentStep > 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Received'),
                        content: const Text(
                          'Your order has been delivered From our side , You will recieve it soon',
                        ),
                        isActive: currentStep > 2,
                        state: currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Delivered'),
                        content: const Text(
                          'Your order has been delivered and signed by you!',
                        ),
                        isActive: currentStep >= 3,
                        state: currentStep >= 3
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
