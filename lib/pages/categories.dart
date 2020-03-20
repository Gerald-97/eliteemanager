import 'package:eliteemanager/components/component_cards.dart';
import 'package:eliteemanager/extras/color.dart';
import 'package:eliteemanager/extras/constants.dart';
import 'package:eliteemanager/methods/api_calls.dart';
import 'package:eliteemanager/models/category.dart';
import 'package:eliteemanager/pages/sub_categories.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool _isLoading = true;

  String _categoryName;

  List<Category> categories = [];

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
                          labelText: 'Add Category',
                          labelStyle: TextStyle(
                            color: AppColor.onBoardButtonColorLight,
                          ),
                          hintText: 'e.g. Food...',
                        ),
                        cursorColor: AppColor.onBoardButtonColorLight,
                        validator: (name) {
                          if(name == null) {
                            return "Please fill the field";
                          } else return null;
                        },
                        onSaved: (name) => _categoryName = name,
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
                        createCat();
                        _formKey.currentState.reset();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
              'Categories',
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
                        children: categories
                            .map((item) => CategoryMenu(item.categoryName, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategories(item),
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
    var getResponse = ApiCall().getCategories();
    getResponse.then((response) {
      setState(() {
        categories.clear();
        getInfo();
        _isLoading = false;
      });
      var responseCode = response["statusCode"];
      if (responseCode >= 300 && responseCode <= 500) {
        showFlushBar(response["message"]);
      } else {
        for (var item in response['data']) {
          categories.add(Category.fromJson(item));
        }
      }
    });
  }

  void createCat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.token);
    var addCategoryResponse = ApiCall().addCategory(_categoryName, token);
    addCategoryResponse.then((response) {
      setState(() {
        _isLoading = false;
      });
      var responseCode = response['statusCode'];
      if(responseCode >= 300 && responseCode <= 500) {
        categories.clear();
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
