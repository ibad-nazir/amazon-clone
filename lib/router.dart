import 'package:ecomerceapp/Common/widgets/bottom_nav.dart';
import 'package:ecomerceapp/features/address/screens/address_screen.dart';
import 'package:ecomerceapp/features/admin/screens/add_product_screens.dart';
import 'package:ecomerceapp/features/auth/screens/login_screen.dart';
import 'package:ecomerceapp/features/cart/screens/cart_screens.dart';
import 'package:ecomerceapp/features/home/screens/category_screen.dart';
import 'package:ecomerceapp/features/order_details/screens/order_details_screen.dart';
import 'package:ecomerceapp/features/product_details/screens/product_details_screens.dart';
import 'package:ecomerceapp/features/search/screens/search_screen.dart';
import 'package:ecomerceapp/models/order.dart';
import 'package:ecomerceapp/models/product.dart';
import 'package:flutter/material.dart';

import 'features/home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomNavBar(),
      );
    case AddProduct.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProduct(),
      );
    case CategoryScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryScreen(categoryTitle: category),
      );
    case ProductDetails.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetails(product: product),
      );

    case SearchScreen.routeName:
      var query = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(query: query),
      );
    case OrderDetailsScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailsScreen(order: order),
      );
    case AddressScreen.routeName:
      var address = routeSettings.arguments as String;
      bool isFromCart = false;
      bool isFromProduct = false;

      if (address == CartScreen.routeName) {
        isFromCart = true;
      } else if (address == ProductDetails.routeName) {
        isFromProduct = true;
      }
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          isFromCart: isFromCart,
          isFromProductDeatails: isFromProduct,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
