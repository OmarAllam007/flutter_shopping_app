import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../screens/edit_product_screen.dart';
import '../provider/product.dart';

class AdminProductItem extends StatelessWidget {
  final Product product;
  AdminProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.purple,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: product.id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context)
                      .delete(product.id)
                      .then((_) {
                    scaffold.showSnackBar(SnackBar(
                      content: Text('Item deleted successfully'),
                      backgroundColor: Colors.green,
                    ));
                  });
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text('Failed to delete the item'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
