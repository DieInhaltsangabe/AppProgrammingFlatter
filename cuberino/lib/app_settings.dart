import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  static final AppSettings _instance = AppSettings._internal();

  //Generate keys/ID's for the setting values
  static const String _fontSizeKey = 'fontSize';
  static const String _languageKey = 'language';
  static const String _fontKey = 'font';
  static const String _backgroundColorKey = 'backgroundColor';
  static const String _cubeZoomKey = 'cubeZoom';

  factory AppSettings() {
    return _instance;
  }

  AppSettings._internal();

  // Standard values for each setting
  double _fontSize = 15.0;
  String _language = "de";
  String _font = "Arial";
  Color _background_color = CupertinoColors.white;
  String _cubeZoom = "Small";

  // loads and applies all Settings from the shared preferences.
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 15.0;
    _language = prefs.getString(_languageKey) ?? "de";
    _font = prefs.getString(_fontKey) ?? "Arial";
    _background_color =
        Color(prefs.getInt(_backgroundColorKey) ?? CupertinoColors.white.value);
    _cubeZoom = prefs.getString(_cubeZoomKey) ?? "Small";
    notifyListeners();
  }

  // saves the currently set Settings
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(_fontSizeKey, _fontSize);
    prefs.setString(_languageKey, _language);
    prefs.setString(_fontKey, _font);
    prefs.setInt(_backgroundColorKey, _background_color.value);
    prefs.setString(_cubeZoomKey, _cubeZoom);
    notifyListeners();
  }

  // getters for each attribute
  double get fontSize => _fontSize;
  String get language => _language;
  String get font => _font;
  Color get background_color => _background_color;
  String get cubeZoom => _cubeZoom;

  // setters for each attribute
  set fontSize(double size) {
    _fontSize = size;
    saveSettings();
  }

  set language(String language) {
    _language = language;
    saveSettings();
  }

  set font(String font) {
    _font = font;
    saveSettings();
  }

  set background_color(Color color) {
    _background_color = color;
    saveSettings();
  }

  set cubeZoom(String zoom) {
    _cubeZoom = zoom;
    saveSettings();
  }
}
