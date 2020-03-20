import 'package:eliteemanager/extras/color.dart';
import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  LargeButton({
    @required this.title,
    @required this.onPressed,
    this.color,
    this.textColor
  });

  final String title;
  final Function onPressed;
  final Color color;
  final textColor;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return FlatButton(
      onPressed: onPressed,
      splashColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: size.width / 3.5),
      color: color ?? AppColor.onBoardButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}


class AdminSettingMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool chevronRight;

  AdminSettingMenu(
      {@required this.title,
        @required this.icon,
        @required this.onTap,
        @required this.chevronRight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        icon,
                        color: AppColor.onBoardButtonColorLight,
                        size: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        title,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                chevronRight
                    ? Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                )
                    : SizedBox(),
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

class AddProductItem extends StatelessWidget {
  final Function onSaved;
  final String labelText, hintText;
  final TextInputType textInputType;

  const AddProductItem({
    @required this.onSaved,
    @required this.labelText,
    @required this.hintText,
    this.textInputType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'e.g: $hintText',
        hintStyle: TextStyle(
          color: Colors.black45,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColor.onBoardButtonColorLight,
        ),
      ),
      cursorColor: AppColor.onBoardButtonColorLight,
      keyboardType: textInputType ?? TextInputType.text,
      onSaved: onSaved,
      validator: (name) {
        if(name == null) {
          return "Please fill the field";
        } else return null;
      },
    );
  }
}