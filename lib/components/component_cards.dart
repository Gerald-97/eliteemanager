import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  final String name;
  final Function onTap;

  CategoryMenu(this.name, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          onLongPress: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 10,
        ),
      ],
    );
  }
}