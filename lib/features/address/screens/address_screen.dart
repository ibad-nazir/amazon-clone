// ignore_for_file: use_build_context_synchronously

import 'package:ecomerceapp/Common/widgets/Loader.dart';
import 'package:ecomerceapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Common/widgets/custom_TextField.dart';
import '../../../Common/widgets/custom_buttom.dart';
import '../../../constants/global_variable.dart';
import '../../../models/product.dart';
import '../services/address_services.dart';

enum Auth {
  thisAddress,
  newAddress,
}

class AddressScreen extends StatefulWidget {
  static const String routeName = 'route\\addressScreen';
  final bool isFromCart;
  final bool isFromProductDeatails;
  final Product? product;
  const AddressScreen(
      {super.key,
      this.isFromCart = false,
      this.isFromProductDeatails = false,
      this.product});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController landMarkController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  void saveAddress() {
    if (globalKey.currentState!.validate()) {
      AddressSevices.saveAddress(
        context: context,
        address:
            '${landMarkController.text} ${streetController.text} ${cityController.text} ${provinceController.text} ',
      );
    }
  }

  String getAddressFromForm() {
    return '${landMarkController.text} ${streetController.text} ${cityController.text} ${provinceController.text} ';
  }

  Auth newAddress = Auth.newAddress;
  @override
  void initState() {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isNotEmpty) {
      newAddress = Auth.thisAddress;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    double sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              if (user.address.isNotEmpty)
                Row(
                  children: [
                    Radio(
                        value: Auth.thisAddress,
                        groupValue: newAddress,
                        onChanged: (Auth? val) {
                          setState(() {
                            newAddress = val!;
                          });
                        }),
                    const Text('Use this  Address'),
                  ],
                ),
              if (user.address.isNotEmpty && newAddress == Auth.thisAddress)
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        user.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'OR',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              if (user.address.isNotEmpty)
                Row(
                  children: [
                    Radio(
                        value: Auth.newAddress,
                        groupValue: newAddress,
                        onChanged: (Auth? val) {
                          setState(() {
                            newAddress = val!;
                          });
                        }),
                    const Text('Add New Address'),
                  ],
                ),
              if (newAddress == Auth.newAddress || user.address.isEmpty)
                Form(
                  key: globalKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: streetController,
                        hintText: 'Enter Street Address',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: cityController,
                        hintText: 'Enter Your City',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: provinceController,
                        hintText: 'Enter Your Province',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: landMarkController,
                        hintText: 'Land Mark (i.e Behind train station)',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (!widget.isFromCart && !widget.isFromProductDeatails)
                        CustomButton(onTap: saveAddress, text: 'Save Address'),
                    ],
                  ),
                ),
              if (widget.isFromCart || widget.isFromProductDeatails)
                CustomButton(
                  onTap: () {
                    if (newAddress == Auth.newAddress) {
                      // saveAddress();
                    }
                    if (newAddress == Auth.thisAddress ||
                        globalKey.currentState!.validate()) {
                      String address = getAddressFromForm();

                      widget.isFromCart
                          ? AddressSevices.placeOrder(
                              context: context,
                              total: sum,
                              address: Auth.thisAddress == newAddress
                                  ? user.address
                                  : address,
                            )
                          : AddressSevices.placeSingle(
                              context: context,
                              address: Auth.thisAddress == newAddress
                                  ? user.address
                                  : address,
                              product: widget.product!,
                            );
                    }

                    showDialog(
                        context: context,
                        builder: (context2) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context2).pop();

                            showDialogBox(widget.isFromCart
                                ? sum
                                : widget.product!.price);
                            if (newAddress == Auth.newAddress) {
                              saveAddress();
                            }
                          });
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Container(
                              height: 100,
                              width: 100,
                              color: Colors.white24,
                              child: const Column(
                                children: [
                                  Loader(),
                                  SizedBox(height: 20),
                                  Text('Paying the Amount '),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  text: 'Pay Now',
                  color: Colors.green,
                )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBox(double sum) {
    showDialog(
        context: context,
        builder: (ctx) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(ctx).pop();
            Navigator.of(context).pop();
          });
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Column(
                children: [
                  const Icon(
                    Icons.check_circle_outline_outlined,
                    color: Colors.green,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'You Just Paid \$$sum',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Order Placed Successfully'),
                ],
              ));
        });
  }
}
