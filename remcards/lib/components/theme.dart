import 'package:flutter/material.dart';

class RemCardsTheme with ChangeNotifier {

  static bool _isDark = false;

  ThemeMode currentTheme(){
    return _isDark? ThemeMode.dark: ThemeMode.light;
  }
  final ThemeData lightTheme = ThemeData(

  );

  void switchTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }
}