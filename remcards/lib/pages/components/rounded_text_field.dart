import 'package:flutter/material.dart';

Widget RoundedTextField(String hintText, Color hintStyleColor, Color fillColor,
    TextEditingController controller, bool obscuretext, double fontSize) {
  return TextField(
    controller: controller,
    obscureText: obscuretext,
    style: TextStyle(color: hintStyleColor, fontSize: fontSize),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: hintStyleColor.withOpacity(0.5)),
        fillColor: fillColor),
  );
}

Widget RoundedOutlineTextField(String hintText, Color hintStyleColor, Color outlineColor,
    TextEditingController controller, bool obscuretext, double fontSize) {
  return TextField(
    controller: controller,
    obscureText: obscuretext,
    style: TextStyle(color: hintStyleColor, fontSize: fontSize),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: outlineColor, width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintText: hintText,
        fillColor: Colors.transparent,
        hintStyle: TextStyle(color: hintStyleColor.withOpacity(0.5))),
  );
}

Widget RoundedTextFieldTap(
    String hintText,
    Color hintStyleColor,
    Color fillColor,
    TextEditingController controller,
    bool obscuretext,
    double fontSize,
    Function onTap) {
  return TextField(
    onTap: onTap,
    controller: controller,
    obscureText: obscuretext,
    style: TextStyle(color: hintStyleColor, fontSize: fontSize),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: hintStyleColor.withOpacity(0.5)),
        fillColor: fillColor),
  );
}
