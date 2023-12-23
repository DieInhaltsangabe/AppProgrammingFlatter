import 'package:flutter/material.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class BackgroundColorSelect extends StatefulWidget {
  @override
  _BackgroundColorSelectState createState() => _BackgroundColorSelectState();
}

class _BackgroundColorSelectState extends State<BackgroundColorSelect> {
  final AppSettings _appSettings = AppSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: _appSettings.background_color,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                _colorPicker(context);
              },
              child: Text(AppLocalizations.of(context)!.changecolor),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Image.asset('assets/rubik.png'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cuberino()));
                },
              ),
            ],
          ),
        ));
  }

  // Color Picker Dialog, which will allow the user to pick the next background color.
  void _colorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _appSettings.background_color,
              onColorChanged: (color) {
                setState(() {
                  _appSettings.background_color = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.errorAccept,
                  style: TextStyle(
                      fontSize: AppSettings().fontSize,
                      fontFamily: AppSettings().font,
                      color: Theme.of(context).colorScheme.onSurface)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
