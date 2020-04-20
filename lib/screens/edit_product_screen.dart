import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/provider/products.dart';
import '../provider/product.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Product _product =
      Product(id: null, title: '', description: '', price: 0.0, imageUrl: '');

  var initalValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageUrlNode.addListener(updateImageUrl);
    super.initState();
  }

  void updateImageUrl() {
    if (!_imageUrlNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    final productId = ModalRoute.of(context).settings.arguments as String;

    if (productId != null) {
      _product = Provider.of<ProductsProvider>(context).show(productId);
      initalValues = {
        'title': _product.title,
        'price': _product.price.toString(),
        'description': _product.description,
        'imageUrl': ''
      };
      _imageUrlController.text = _product.imageUrl;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlNode.removeListener(updateImageUrl);
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_product.id != null) {
      await Provider.of<ProductsProvider>(context).update(_product);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .store(_product);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: initalValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (value) {
                          _product = Product(
                              id: _product.id,
                              isFavourite: _product.isFavourite,
                              title: value,
                              description: _product.description,
                              price: _product.price,
                              imageUrl: _product.imageUrl);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a title.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initalValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            isFavourite: _product.isFavourite,
                            title: _product.title,
                            description: _product.description,
                            price: double.parse(value),
                            imageUrl: _product.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a price.';
                          }

                          if (double.tryParse(value) == null) {
                            return 'Please Enter a valid price number';
                          }

                          if (double.parse(value) <= 0) {
                            return 'Please Enter a number greater than zero.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initalValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            isFavourite: _product.isFavourite,
                            title: _product.title,
                            description: value,
                            price: _product.price,
                            imageUrl: _product.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a description.';
                          }

                          if (value.length < 5) {
                            return 'Please Enter a description chars more than 5.';
                          }

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            margin: EdgeInsets.only(top: 10, right: 5),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter URl')
                                : FittedBox(
                                    child: Image.network(
                                      '${_imageUrlController.text}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URl'),
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                setState(() {});
                              },
                              onSaved: (value) {
                                _product = Product(
                                  id: _product.id,
                                  isFavourite: _product.isFavourite,
                                  title: _product.title,
                                  description: _product.description,
                                  price: _product.price,
                                  imageUrl: value,
                                );
                              },
                              focusNode: _imageUrlNode,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
