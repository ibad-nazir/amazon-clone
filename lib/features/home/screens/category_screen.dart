import 'package:ecomerceapp/Common/widgets/Loader.dart';
import 'package:ecomerceapp/features/home/services/home_services.dart';
import 'package:ecomerceapp/features/product_details/screens/product_details_screens.dart';
import 'package:ecomerceapp/models/product.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variable.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.categoryTitle});
  final String categoryTitle;
  static const String routeName = "route\\CategoryScreen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Product>? products;
  @override
  void initState() {
    showProducts();
    super.initState();
  }

  void showProducts() async {
    products = await HomeServices.showProducts(
        context: context, category: widget.categoryTitle);
    setState(() {});
  }

  void moveToDetailsScreen(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetails.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Text(
              widget.categoryTitle,
              style: const TextStyle(color: Colors.black),
            )),
      ),
      body: products == null
          ? const Loader()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Keep Shopping in ${widget.categoryTitle}",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products!.length,
                      padding: const EdgeInsets.only(left: 15),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.4,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            moveToDetailsScreen(products![index]);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 130,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.network(
                                      products![index].images[0],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 5, right: 15),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  products![index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
    );
  }
}
