import 'package:ecomerceapp/constants/global_variable.dart';

import 'package:ecomerceapp/features/home/screens/category_screen.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  void moveToCategoryScreen(BuildContext context, String title) {
    Navigator.of(context).pushNamed(CategoryScreen.routeName, arguments: title);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        itemCount: GlobalVariables.categoryImages.length,
        scrollDirection: Axis.horizontal,
        itemExtent: 80,
        itemBuilder: (ctx, idx) => Column(
          children: [
            GestureDetector(
              onTap: () {
                moveToCategoryScreen(
                    context, GlobalVariables.categoryImages[idx]['title']!);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    GlobalVariables.categoryImages[idx]['image']!,
                    fit: BoxFit.cover,
                    height: 46,
                    width: 46,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              GlobalVariables.categoryImages[idx]['title']!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
