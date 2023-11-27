import 'package:flutter/cupertino.dart';

class AppSettings with ChangeNotifier{
  static final AppSettings _instance = AppSettings._internal();

  factory AppSettings() {
    return _instance;
  }

  AppSettings._internal();

  double _fontSize = 15.0;
  String _language = "de";

  double get fontSize => _fontSize;
  String get language => _language;

  set fontSize(double size) {
    _fontSize = size;
  }
  set language(String language){
    _language = language;
    notifyListeners();
  }
}