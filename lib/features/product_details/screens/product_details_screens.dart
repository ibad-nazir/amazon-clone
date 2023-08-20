import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecomerceapp/Common/widgets/stars.dart';
import 'package:ecomerceapp/constants/utils.dart';
import 'package:ecomerceapp/features/address/screens/address_screen.dart';
import 'package:ecomerceapp/features/product_details/services/product_details_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../../Common/widgets/custom_buttom.dart';
import '../../../constants/global_variable.dart';
import '../../../models/product.dart';
import '../../../provider/user_provider.dart';
import '../../search/screens/search_screen.dart';

class ProductDetails extends StatefulWidget {
  static const String routeName = "route\\ProductDetails";
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool addedToCard = false;
  void onFieldSubmitted(String query) {
    Navigator.popAndPushNamed(context, SearchScreen.routeName,
        arguments: query);
  }

  double myRating = 0;
  bool orignal = false;
  double avgRating = 0;

  getCartInfo() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    for (var i = 0; i < userProvider.user.cart.length; i++) {
      if (widget.product.id == userProvider.user.cart[i]['product']['_id']) {
        addedToCard = true;
        orignal = true;
      }
    }
  }

  @override
  void initState() {
    addedToCard = false;
    getCartInfo();
    super.initState();

    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (addedToCard) {
          if (orignal != addedToCard) {
            ProductDetailsServices.addToCart(
                context: context, product: widget.product);
          }
        } else {
          ProductDetailsServices.removeFromCart(
              context: context, product: widget.product);
        }

        return true;
      },
      child: Scaffold(
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
        floatingActionButton: FloatingActionButton(
            tooltip: 'Add to Cart',
            backgroundColor: !addedToCard
                ? GlobalVariables.secondaryColor
                : Colors.red.shade900,
            onPressed: () {
              setState(() {
                addedToCard = !addedToCard;
              });
              addedToCard
                  ? showSnackBar(context, 'Added to Cart')
                  : showSnackBar(context, 'Removed from Cart');
            },
            child: addedToCard
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: 45, // 45 degrees in radians
                        child: Container(
                          width: 3.0, // Adjust the width of the line
                          height: 50.0, // Adjust the height of the line
                          color:
                              Colors.black, // Change the color of the line here
                        ),
                      ),
                      const Icon(
                        Icons.shopping_cart,
                      ),
                    ],
                  )
                : const Icon(
                    Icons.shopping_cart,
                  )),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.product.id!),
                    StarsWidget(
                      rating: avgRating,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 0.5,
                    ),
                  ),
                  child: CarouselSlider(
                    items: widget.product.images.map((e) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(
                            e,
                            fit: BoxFit.contain,
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: 300,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs. ${widget.product.price}0/-',
                      style: TextStyle(
                        fontSize: 24,
                        color:
                            const Color.fromARGB(227, 0, 0, 0).withOpacity(0.9),
                        wordSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Available - In Stock - (${widget.product.quantity.toInt()})',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade700),
                    const SizedBox(
                      width: 2,
                    ),
                    Text('$avgRating/5'),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      ' Reviews (${widget.product.rating!.length})',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const Icon(Icons.arrow_right_outlined,
                        size: 25, color: Colors.black),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddressScreen(
                            isFromCart: false,
                            isFromProductDeatails: true,
                            product: widget.product,
                          ),
                        ));
                  },
                  text: 'Buy - Now',
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.product.description),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Rate this Product',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: myRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: GlobalVariables.secondaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    ProductDetailsServices.rateProduct(
                      context: context,
                      product: widget.product,
                      rating: rating,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
