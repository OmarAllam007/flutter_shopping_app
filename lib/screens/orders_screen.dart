import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../provider/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  Widget build(BuildContext context) {
  
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context,listen: false).getLatestOrders(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, child) {
                 return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItemWidget(ordersData.orders[index]);
                    },
                    itemCount: ordersData.orders.length,
                  );
                },
              );
            }
          },
        ));
  }
}
