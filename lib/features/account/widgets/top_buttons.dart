import 'package:ecomerceapp/features/account/services/account_services.dart';
import 'package:ecomerceapp/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: ' Your Orders ',
              onPressed: () {},
            ),
            AccountButton(
              text: ' Turn Seller ',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AccountButton(
              text: ' Your WishList  ',
              onPressed: () {},
            ),
            AccountButton(
              text: ' Turn Logout ',
              onPressed: () {
                AccountServices.logOut(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
