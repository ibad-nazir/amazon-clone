import 'package:flutter/material.dart';

import '../../../models/product.dart';

class SingleOrderProduct extends StatelessWidget {
  final Product product;
  const SingleOrderProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.1,
              color: Colors.black12,
            ),
          ),
          child: Image.network(
            product.images[0],
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 5),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity ${product.quantity.toInt()}x',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 1,
                    width: 30,
                  ),
                  Container(
                    height: 25,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                      color: Colors.teal.shade300,
                    ),
                    child: const Center(child: Text('Paid')),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
