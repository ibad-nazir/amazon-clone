import 'package:ecomerceapp/Common/widgets/Loader.dart';
import 'package:ecomerceapp/features/account/widgets/single_product.dart';
import 'package:ecomerceapp/features/admin/screens/add_product_screens.dart';
import 'package:ecomerceapp/features/admin/services/admin_services.dart';
import 'package:ecomerceapp/models/product.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products;
  @override
  void initState() {
    fetchAllProducts();
    super.initState();
  }

  fetchAllProducts() async {
    products = await AdminServices.showProducts(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (vtx, index) {
                Product productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(
                        image: productData.images[0],
                        
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                AdminServices.deleteProduct(
                                    productData, context, function: () {
                                  setState(() {
                                    products!.remove(products![index]);
                                  });
                                });
                              },
                              icon: const Icon(Icons.delete_outlined)),
                        ],
                      ),
                    ),
                  ],
                );
              },
              itemCount: products!.length,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AddProduct.routeName);
              },
              tooltip: 'Add a Product',
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
