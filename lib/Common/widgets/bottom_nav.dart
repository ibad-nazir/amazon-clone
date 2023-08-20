import 'package:ecomerceapp/features/cart/screens/cart_screens.dart';
import 'package:ecomerceapp/constants/global_variable.dart';
import 'package:ecomerceapp/features/account/screens/account_screen.dart';
import 'package:ecomerceapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../../features/home/screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  static const String routeName = "route\\BottomNavBar";

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  double bottomWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];
  void setPage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).user;
    return Scaffold(
        body: pages[_page],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          selectedItemColor: GlobalVariables.selectedNavBarColor,
          unselectedItemColor: GlobalVariables.unselectedNavBarColor,
          backgroundColor: GlobalVariables.backgroundColor,
          iconSize: 28,
          onTap: setPage,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                width: bottomWidth,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _page == 0
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: const Icon(Icons.home_outlined),
              ),
              label: ' ',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: bottomWidth,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _page == 1
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.person_outline_outlined,
                ),
              ),
              label: ' ',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(top: 5),
                width: bottomWidth,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _page == 2
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: badges.Badge(
                  badgeContent: Text(userProvider.cart.length.toString()),
                  badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.white, elevation: 0),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                  ),
                ),
              ),
              label: ' ',
            ),
          ],
        ));
  }
}
