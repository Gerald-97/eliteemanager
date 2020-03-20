import 'package:eliteemanager/components/widgets.dart';
import 'package:eliteemanager/extras/color.dart';
import 'package:eliteemanager/pages/categories.dart';
import 'package:eliteemanager/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  final String firstName;

  Dashboard(this.firstName);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.onBoardButtonColorLight,
        title: Text('E-Mart Manager'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: size.height / 6,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Welcome, ${widget.firstName}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25,
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          logoutAdmin();
                        },
                        splashColor: AppColor.onBoardButtonColorLight,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width / 13,
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: AppColor.onBoardButtonColor,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.onBoardButtonColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
              ),
              AdminSettingMenu(
                title: 'Add Products',
                icon: Icons.add,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Categories(),
                    ),
                  );
                },
                chevronRight: true,
              ),
              AdminSettingMenu(
                title: 'View Categories',
                icon: Icons.border_all,
                onTap: () {},
                chevronRight: true,
              ),
              AdminSettingMenu(
                title: 'View All Products',
                icon: Icons.shop,
                onTap: () {},
                chevronRight: true,
              ),
              AdminSettingMenu(
                title: 'All Users',
                icon: Icons.people,
                onTap: () {},
                chevronRight: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logoutAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) {
        return Login();
      },
    ), (Route<dynamic> route) => false);
  }
}
