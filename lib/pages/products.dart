import 'package:eliteemanager/components/products_grid.dart';
import 'package:eliteemanager/components/widgets.dart';
import 'package:eliteemanager/extras/color.dart';
import 'package:eliteemanager/extras/constants.dart';
import 'package:eliteemanager/methods/api_calls.dart';
import 'package:eliteemanager/models/product.dart';
import 'package:eliteemanager/models/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  final SubCategory item;

  ProductPage(this.item);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];

  String _slugName;
  String _productName;
  String _productImage;
  String _productPrice;
  String _productQty;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.onBoardButtonColorLight,
        title: Text('E-Mart Manager'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: AddProductItem(
                              onSaved: (name) => _slugName = name,
                              hintText: 'LG slim led tv 41 inches',
                              labelText: "Slug",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AddProductItem(
                              onSaved: (name) => _productName = name,
                              hintText: '41 inches LG led TV',
                              labelText: "Product name",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: AddProductItem(
                              onSaved: (val) => _productPrice = val,
                              hintText: '100000',
                              labelText: "Price",
                              textInputType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AddProductItem(
                              onSaved: (val) => _productQty = val,
                              hintText: '15',
                              labelText: "Quantity",
                              textInputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: AddProductItem(
                                onSaved: (val) => _productImage = val,
                                hintText: 'https://images.google.com/sample.jpg',
                                labelText: "Web Image",
                                textInputType: TextInputType.url,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: FlatButton(
                                  color: AppColor.onBoardButtonColor,
                                  splashColor: AppColor.onBoardButtonColorLight,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                    }
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    addProduct();
                                    _formKey.currentState.reset();
                                  },
                                  child: Text(
                                    'ADD PRODUCT',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.item.subCategoryName.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.onBoardButtonColor,
              ),
              textAlign: TextAlign.start,
            ),
            Divider(
              color: AppColor.onBoardButtonColorLight,
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: AppColor.onBoardButtonColorLight,
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 3,
                      children: products.map((item) {
                        return productGrid(context, item, widget.item);
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.token);
    var getResponse = ApiCall().getProducts(widget.item.id.toString(), token);
    getResponse.then((response) {
      setState(() {
        _isLoading = false;
      });
      var responseCode = response["statusCode"];
      if (responseCode >= 300 && responseCode <= 500) {
        showFlushBar(response["message"]);
      } else {
        for (var item in response['data']) {
          products.add(Product.fromJson(item));
        }
      }
    });
  }

  void addProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.token);
    print('Running add');
    Map<String, dynamic> body = {
      "slug": _slugName,
      "product_name": _productName,
      "product_price": int.parse(_productPrice),
      "product_avatar": _productImage,
      "product_category": widget.item.categoryId,
      "product_sub_category": widget.item.id,
      "product_quantity": int.parse(_productQty)
    };
    var addResponse = ApiCall().addProducts(body, token);
    addResponse.then((response) {
      setState(() {
        _isLoading = false;
      });
      var responseCode = response["statusCode"];
      if (responseCode >= 300 && responseCode <= 500) {
        products.clear();
        getInfo();
        showFlushBar(response["message"]);
      } else {
        for (var item in response['data']) {
          products.add(Product.fromJson(item));
        }
      }
    });

  }

  void showFlushBar(String message) {
    Flushbar(
      messageText: Text(
        message,
        style: TextStyle(color: Colors.black87),
      ),
      borderColor: AppColor.onBoardButtonColorLight,
      backgroundColor: Colors.white70,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
