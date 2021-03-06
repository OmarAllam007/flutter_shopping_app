import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details.dart';
import './screens/cart_screen.dart';
import './screens/admin_manage_products_screen.dart';

import './provider/orders.dart';
import './provider/cart.dart';
import './provider/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
          ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.redAccent,
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetails.routeName: (ctx) => ProductDetails(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName : (ctx)=> OrdersScreen(),
          AdminProductsScreen.routeName : (ctx)=> AdminProductsScreen(),
          EditProduct.routeName : (ctx)=> EditProduct()
        },
      ),
    );
  }
}
