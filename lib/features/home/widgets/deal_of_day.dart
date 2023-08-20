import 'package:ecomerceapp/Common/widgets/stars.dart';
import 'package:flutter/material.dart';

import '../../../Common/widgets/Loader.dart';
import '../../../models/product.dart';
import '../../product_details/screens/product_details_screens.dart';
import '../services/home_services.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? dealofDay;
  @override
  void initState() {
    getDealOfDay();
    super.initState();
  }

  double avgRating = 0;

  void getDealOfDay() async {
    dealofDay = await HomeServices.getProductofDay(context);
    double totalRating = 0;
    // print(dealofDay!.rating!.length);
    for (int i = 0; i < dealofDay!.rating!.length; i++) {
      totalRating += dealofDay!.rating![i].rating;
    }
    if (totalRating != 0) {
      avgRating = totalRating / dealofDay!.rating!.length;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return dealofDay == null
        ? const Loader()
        : dealofDay!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetails.routeName,
                    arguments: dealofDay,
                  );
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 15,
                      ),
                      child: const Text(
                        "Deal of the day",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.network(
                      dealofDay!.images[0],
                      height: 235,
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.topLeft,
                            child: Text(
                              '\$ ${dealofDay!.price}',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          StarsWidget(rating: avgRating),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 2, right: 40, bottom: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        dealofDay!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15)
                          .copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'See all Deals',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 123, 134),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
