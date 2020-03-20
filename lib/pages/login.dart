import 'package:eliteemanager/components/widgets.dart';
import 'package:eliteemanager/extras/color.dart';
import 'package:eliteemanager/extras/constants.dart';
import 'package:eliteemanager/methods/api_calls.dart';
import 'package:eliteemanager/models/admin.dart';
import 'package:eliteemanager/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _myController = TextEditingController();

  String _email;
  String _password;
  ChatData chatData;

  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.onBoardButtonColorLight,
        title: Text('E-Mart Manager'),
        elevation: 0,
        leading: !Navigator.canPop(context)
            ? null
            : BackButton(
          color: Colors.black54,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0, top: 20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintStyle: TextStyle(
                            color: AppColor.loginFormFont,
                          ),
                        ),
                        validator: (email) => EmailValidator.validate(email)
                            ? null
                            : 'Invalid Email',
                        onSaved: (email) => _email = email,
                      ),
                      SizedBox(
                        height: size.width / 9,
                      ),
                      TextFormField(
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintStyle: TextStyle(
                            color: AppColor.loginFormFont,
                          ),
                        ),
                        validator: (password) {
                          if (password.length < 3) {
                            return 'Password must be more than 6 characters';
                          } else
                            return null;
                        },
                        onSaved: (password) => _password = password,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Forgot your password?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColor.forgotPassword,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ),
                      SizedBox(
                        height: size.height / 9,
                      ),
                      LargeButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                          }
                          setState(() {
                            isLoading = true;
                          });
                          loginAdmin();
                        },
                        color: isLoading ? Colors.grey : AppColor.onBoardButtonColor,
                        title: isLoading ? 'Please wait...' : 'Sign In',
                        textColor: isLoading ? Colors.black87 : Colors.white,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Divider(
                        color: AppColor.loginFormFont,
                        thickness: 1.5,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginResponse = ApiCall().loginAdmin(_email, _password);
    loginResponse.then((response) {
      setState(() {
        isLoading = false;
      });
      var responseCode = response['statusCode'];
      if (responseCode >= 300 && responseCode <= 500) {
        showFlushBar(response['message']);
      } else {
        showFlushBar(response['message']);
        chatData = ChatData.fromJson(response['data']);
        
        prefs.setString(Constants.id, chatData.id.toString());
        prefs.setString(Constants.firstName, chatData.firstName);
        prefs.setString(Constants.lastName, chatData.lastName);
        prefs.setString(Constants.email, chatData.email);
        prefs.setString(Constants.token, chatData.token);

        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) {
              return Dashboard(prefs.getString(Constants.firstName));
            },
          ), (Route<dynamic> route) => false);
        });
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
