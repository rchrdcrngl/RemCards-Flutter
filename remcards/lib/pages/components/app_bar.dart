import 'package:flutter/material.dart';

AppBar rcAppBar({String text, BuildContext context}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    iconTheme: IconThemeData(color: Colors.black),
    title: Text(text,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700)),
  );
}

AppBar rcAppBarActions({String text, List<Widget> actions, BuildContext context}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    iconTheme: IconThemeData(color: Colors.black),
    actions: actions,
    title: Text(text,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700)),
  );
}
