import 'package:eliteemanager/components/component_cards.dart';
import 'package:eliteemanager/extras/color.dart';
import 'package:eliteemanager/extras/constants.dart';
import 'package:eliteemanager/methods/api_calls.dart';
import 'package:eliteemanager/models/category.dart';
import 'package:eliteemanager/models/sub_category.dart';
import 'package:eliteemanager/pages/products.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SubCategories extends StatefulWidget {
  final Category item;

  SubCategories(this.item);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  final _formKey = GlobalKey<FormState>();

  List<SubCategory> subCategories = [];

  String _subCategoryName;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.onBoardButtonColorLight,
        title: Text('E-Mart Manager'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: size.width / 1.5,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Add Sub-Category',
                          labelStyle: TextStyle(
                              color: AppColor.onBoardButtonColorLight),
                          hintText: 'e.g. Food...',
                        ),
                        cursorColor: AppColor.onBoardButtonColorLight,
                        validator: (name) {
                          if(name == null) {
                            return "Please fill the field";
                          } else return null;
                        },
                        onSaved: (name) => _subCategoryName = name,
                      ),
                    ),
                    FlatButton(
                      color: AppColor.onBoardButtonColor,
                      splashColor: AppColor.onBoardButtonColorLight,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        addSubCat();
                        _formKey.currentState.reset();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.item.categoryName.toUpperCase(),
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
                  : SingleChildScrollView(
                      child: Column(
                        children: subCategories
                            .map((item) =>
                                CategoryMenu(item.subCategoryName, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(item),
                                    ),
                                  );
                                }))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void getInfo() async {
    var getResponse = ApiCall().getSubCategories(widget.item.id.toString());
    getResponse.then((response) {
      setState(() {
        _isLoading = false;
      });
      var responseCode = response["statusCode"];
      if (responseCode >= 300 && responseCode <= 500) {
        showFlushBar(response["message"]);
      } else {
        for (var item in response['data']) {
          subCategories.add(SubCategory.fromJson(item));
        }
      }
    });
  }

  void addSubCat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.token);
    var response = ApiCall().addSubCategory(widget.item.id.toString(), _subCategoryName, token);
    response.then((response) {
      setState(() {
        _isLoading = false;
      });
      var responseCode = response['statusCode'];
      if(responseCode >= 300 && responseCode <= 500) {
        subCategories.clear();
        getInfo();
        showFlushBar(response['message']);
      }
      else {
        showFlushBar(response['message']);
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
