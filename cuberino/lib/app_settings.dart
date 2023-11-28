import 'package:flutter/cupertino.dart';

class AppSettings with ChangeNotifier{
  static final AppSettings _instance = AppSettings._internal();

  factory AppSettings() {
    return _instance;
  }

  AppSettings._internal();

  double _fontSize = 15.0;
  String _language = "de";
  String _font = "Arial";

  double get fontSize => _fontSize;
  String get language => _language;
  String get font => _font;

  set fontSize(double size) {
    _fontSize = size;
  }
  set language(String language){
    _language = language;
    notifyListeners();
  }
  set font(String font){
    _font = font;
    notifyListeners();
  }
}