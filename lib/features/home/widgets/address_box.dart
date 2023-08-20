import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';
import '../../address/screens/address_screen.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({super.key});

  void moveToAddressScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(AddressScreen.routeName, arguments: 'address-Box');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return InkWell(
      onTap: () {
        moveToAddressScreen(context);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 114, 226, 221),
              Color.fromARGB(255, 162, 236, 233),
            ],
            stops: [0.5, 1.0],
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  'Deliver to ${user.name}- ${user.address}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5, top: 2),
              child: Icon(
                Icons.arrow_drop_down_outlined,
                size: 22,
              ),
            )
          ],
        ),
      ),
    );
  }
}
