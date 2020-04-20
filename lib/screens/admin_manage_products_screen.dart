import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/admin_product_item.dart';
import '../provider/products.dart';

class AdminProductsScreen extends StatelessWidget {
  static const routeName = '/admin-products';
  
  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<ProductsProvider>(context).index();
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=> _refreshProducts(context),

              child: ListView.builder(
          itemBuilder: (ctx, i) => AdminProductItem(provider.products[i]),
          itemCount: provider.products.length,
        ),
      ),
    );
  }
}
