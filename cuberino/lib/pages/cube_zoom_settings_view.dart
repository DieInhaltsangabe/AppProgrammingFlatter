import 'package:flutter/material.dart';
import 'package:cuberino/app_settings.dart';
import 'package:cuberino/main.dart';

import '../components/bottom_app_bar.dart';

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
                Text('Select Cube Zoom Size',
                  style: TextStyle(fontSize: _appSettings.fontSize, fontFamily: _appSettings.font),
                ),
                CheckboxListTile(
                  title: Text('Small', style: TextStyle(fontSize: _appSettings.fontSize, fontFamily: _appSettings.font),),
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
                  title: Text('Medium', style: TextStyle(fontSize: _appSettings.fontSize, fontFamily: _appSettings.font),),
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
                  title: Text('Large', style: TextStyle(fontSize: _appSettings.fontSize, fontFamily: _appSettings.font),),
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
            )
        ),
        bottomNavigationBar: BottomMenu(false, true, false, true)
    );
  }
}