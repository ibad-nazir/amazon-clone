import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecomerceapp/Common/widgets/custom_TextField.dart';
import 'package:ecomerceapp/Common/widgets/custom_buttom.dart';
import 'package:ecomerceapp/constants/utils.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variable.dart';
import '../services/admin_services.dart';

class AddProduct extends StatefulWidget {
  static const String routeName = "route\\AddProduct";
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productQuantityController =
      TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final globalKey = GlobalKey<FormState>();

  List<String> titles = GlobalVariables.categoryImages
      .map((category) => category['title']!)
      .toList();
  String category = GlobalVariables.categoryImages[0]['title']!;


  List<File> images = [];

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void sellProduct() {
    if (globalKey.currentState!.validate() && images.isNotEmpty) {
      AdminServices().sellProduct(
        context: context,
        name: productNameController.text,
        description: productDescriptionController.text,
        price: double.parse(productPriceController.text),
        quantity: double.parse(productQuantityController.text),
        category: category,
        images: images,
      );
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    productQuantityController.dispose();
    productDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: const Text(
              'Add a Product ',
              style: TextStyle(color: Colors.black),
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: selectImages,
                  child: images.isNotEmpty
                      ? CarouselSlider(
                          items: images.map((e) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Image.file(
                                  e,
                                  fit: BoxFit.cover,
                                  height: 200,
                                );
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 200,
                          ),
                        )
                      : DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open, size: 40),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Add Product Image',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: productDescriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: productPriceController,
                  hintText: 'Price',
                  isNumber: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: productQuantityController,
                  hintText: 'Quantity',
                  isNumber: true,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: titles.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? check) {
                      setState(() {
                        category = check!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(onTap: sellProduct, text: 'Sell'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
