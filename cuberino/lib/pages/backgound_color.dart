import 'package:flutter/material.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cuberino/components/bottom_app_bar.dart';


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
      bottomNavigationBar: BottomMenu(false, true, false)
    );
  }

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
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
