import 'package:flutter/material.dart';

AppBar rcAppBar({String text, BuildContext context}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    iconTheme: IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
    title: Text(text,
        style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
            fontWeight: FontWeight.w700)),
  );
}

AppBar rcAppBarActions({String text, List<Widget> actions, BuildContext context}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    iconTheme: IconThemeData(color: Theme.of(context).textTheme.bodyText1.color),
    actions: actions,
    title: Text(text,
        style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
            fontWeight: FontWeight.w700)),
  );
}
