import 'package:flutter/material.dart';
import 'package:cuberino/app_settings.dart';
import 'package:cuberino/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CubeZoom extends StatefulWidget {
  const CubeZoom({Key? key}) : super(key: key);
  @override
  _CubeZoomSettingsState createState() => _CubeZoomSettingsState();
}

class _CubeZoomSettingsState extends State<CubeZoom> {
  final AppSettings _appSettings = AppSettings();
  List<String> fonts = ["Small", "Middle", "Large"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.cubeZoom,
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
              value: _appSettings.cubeZoom == "Small",
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    _appSettings.cubeZoom = "Small";
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
              value: _appSettings.cubeZoom == "Medium",
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    _appSettings.cubeZoom = "Medium";
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
              value: _appSettings.cubeZoom == "Large",
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    _appSettings.cubeZoom = "Large";
                  });
                }
              },
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
