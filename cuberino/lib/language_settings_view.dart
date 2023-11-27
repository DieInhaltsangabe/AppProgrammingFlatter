import 'package:flutter/material.dart';
import 'app_settings.dart';
import 'main.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({Key? key}) : super(key: key);
  @override
  _LanguageSettingsState createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  final AppSettings _appSettings = AppSettings();
  var items = ['en', 'de', 'tr'];
  var display = ['English', 'Deutsch', 'Türkçe'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: _appSettings.language,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String item) {
                int indexOfItem = items.indexOf(item);
                return DropdownMenuItem(
                  value: item,
                  child: Text(display[indexOfItem]),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _appSettings.language = newValue.toString();
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Image.asset('assets/rubik.png'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Cuberino()));
              },
            ),
          ],
        ),
      ),
    );
  }
}