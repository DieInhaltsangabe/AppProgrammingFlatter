import 'package:flutter/material.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class FontSettingsView extends StatefulWidget {
  @override
  _FontSettingsViewState createState() => _FontSettingsViewState();
}

class _FontSettingsViewState extends State<FontSettingsView> {
  final AppSettings _appSettings = AppSettings();
  List<String> fonts = ["Arial", "Monospace", "Times New Roman"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.fontsize,
              style: TextStyle(
                  fontSize: _appSettings.fontSize,
                  fontFamily: _appSettings.font),
            ),
            CheckboxListTile(
              title: Text(
                AppLocalizations.of(context)!.small,
                style: TextStyle(
                    fontSize: _appSettings.fontSize,
                    fontFamily: _appSettings.font),
              ),
              value: _appSettings.fontSize == 15.0,
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    _appSettings.fontSize = 15.0;
                  });
                }
              },
            ),
            CheckboxListTile(
              title: Text(
                AppLocalizations.of(context)!.medium,
                style: TextStyle(
                    fontSize: _appSettings.fontSize,
                    fontFamily: _appSettings.font),
              ),
              value: _appSettings.fontSize == 17.0,
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    _appSettings.fontSize = 17.0;
                  });
                }
              },
            ),
            CheckboxListTile(
              title: Text(
                AppLocalizations.of(context)!.large,
                style: TextStyle(
                    fontSize: _appSettings.fontSize,
                    fontFamily: _appSettings.font),
              ),
              value: _appSettings.fontSize == 20.0,
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    _appSettings.fontSize = 20.0;
                  });
                }
              },
            ),
            Divider(),
            Text(
              AppLocalizations.of(context)!.fontfamily,
              style: TextStyle(
                  fontSize: _appSettings.fontSize,
                  fontFamily: _appSettings.font),
            ),
            DropdownButton<String>(
              value: _appSettings.font,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _appSettings.font = value;
                  });
                }
              },
              items: fonts.map((String fontFamily) {
                return DropdownMenuItem<String>(
                  value: fontFamily,
                  child: Text('Font: $fontFamily',
                      style: TextStyle(fontFamily: fontFamily)),
                );
              }).toList(),
            ),
          ],
        )),
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
}
