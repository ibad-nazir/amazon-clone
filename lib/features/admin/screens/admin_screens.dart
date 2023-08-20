import 'package:ecomerceapp/features/account/services/account_services.dart';
import 'package:ecomerceapp/features/admin/screens/analytics_screen.dart';
import 'package:ecomerceapp/features/admin/screens/orders_screen.dart';
import 'package:ecomerceapp/features/admin/screens/post_screen.dart';
import 'package:flutter/material.dart';
import '../../../constants/global_variable.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const OrderScreen(),
    const PostScreen(),
    const AnalyticsScreen(),
  ];
  void setPage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Admin  ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                  onPressed: () {
                    AccountServices.logOut(context);
                  },
                  icon: const Icon(Icons.logout)),
            ],
          ),
        ),
      ),
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
                Icons.inbox_outlined,
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
              child: const Icon(
                Icons.analytics_outlined,
              ),
            ),
            label: ' ',
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}
