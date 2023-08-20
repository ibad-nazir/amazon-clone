import 'package:ecomerceapp/Common/widgets/stars.dart';
import 'package:flutter/material.dart';
import '../../../models/product.dart';

class SearchedProduct extends StatefulWidget {
  const SearchedProduct({super.key, required this.product});
  final Product product;

  @override
  State<SearchedProduct> createState() => _SearchedProductState();
}

class _SearchedProductState extends State<SearchedProduct> {
  double avgRating = 0;

  @override
  void initState() {
    super.initState();
    double totalRating = 0;

    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Image.network(
                widget.product.images[0],
                height: 135,
                width: 135,
                fit: BoxFit.contain,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.product.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: StarsWidget(rating: avgRating),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      '\$${widget.product.price}',
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: const Text('Eligible For free Shipping'),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      widget.product.quantity == 0
                          ? ' Out of Stock'
                          : 'In Stock',
                      maxLines: 2,
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
