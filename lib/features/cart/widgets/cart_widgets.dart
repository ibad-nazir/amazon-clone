
import 'package:ecomerceapp/features/product_details/services/product_details_services.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';

class CartProduct extends StatefulWidget {
  final Product product;
  const CartProduct({super.key, required this.product});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
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
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.product.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      '\$${widget.product.price}',
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: const Text('Eligible For free Shipping'),
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: const Text(
                      'In Stock',
                      maxLines: 2,
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    ProductDetailsServices.removeFromCart(
                        context: context, product: widget.product);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: AlignmentDirectional.center,
                  child:
                      const Icon(Icons.delete, color: Colors.teal, size: 30.0),
                ),
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
