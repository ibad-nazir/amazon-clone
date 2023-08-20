import 'package:ecomerceapp/Common/widgets/Loader.dart';
import 'package:ecomerceapp/features/home/widgets/address_box.dart';
import 'package:ecomerceapp/features/search/services/search_services.dart';
import 'package:ecomerceapp/features/search/widgets/searched_products.dart';
import 'package:ecomerceapp/models/product.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variable.dart';
import '../../product_details/screens/product_details_screens.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "route\\SearchScreen";
  final String query;
  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  fetchProducts() async {
    products = await SearchServices.searchProducts(
        context: context, query: widget.query);
    setState(() {});
  }

  void moveToDetailsScreen(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetails.routeName,
      arguments: product,
    );
  }

  void onFieldSubmitted(String query) {
    Navigator.popAndPushNamed(context, SearchScreen.routeName,
        arguments: query);
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
                      initialValue: widget.query,
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
                        hintText: 'Search Amazon.pk',
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
      body: products == null
          ? const Loader()
          : products!.isEmpty
              ? const Center(child: Text('No Products Available '))
              : Column(
                  children: [
                    const AddressBox(),
                    const SizedBox(height: 10),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            moveToDetailsScreen(products![index]);
                          },
                          child: SearchedProduct(product: products![index]),
                        );
                      },
                      itemCount: products!.length,
                    ),
                  ],
                ),
    );
  }
}
