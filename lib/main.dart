import 'package:eliteemanager/extras/constants.dart';
import 'package:eliteemanager/pages/dashboard.dart';
import 'package:eliteemanager/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String token = (await SharedPreferences.getInstance()).getString(Constants.token);
  bool _isLoggedIn = token != null ? true : false;

  String firstName = (await SharedPreferences.getInstance()).getString(Constants.firstName);

  runApp(MyApp(_isLoggedIn, firstName));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String firstName;

  const MyApp(this.isLoggedIn, this.firstName);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? Dashboard(this.firstName) : Login(),
    );
  }
}