import 'package:cuberino/pages/backgound_color.dart';
import 'package:flutter/material.dart';
import 'cube_zoom_settings_view.dart';
import 'font_settings_view.dart';
import 'language_settings_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body:
      ListView(
        children: [
          ListNavigation(AppLocalizations.of(context)!.language, (){Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettings()));}),
          ListNavigation("Font", (){Navigator.push(context, MaterialPageRoute(builder: (context) => FontSettingsView()));}),
          ListNavigation(AppLocalizations.of(context)!.backgroundcolor, (){Navigator.push(context, MaterialPageRoute(builder: (context) => BackgroundColorSelect()));}),
          ListNavigation(AppLocalizations.of(context)!.cubeZoomSettings, (){Navigator.push(context, MaterialPageRoute(builder: (context) => CubeZoom()));})
        ],
      ),
    );
  }
}

class ListNavigation extends StatelessWidget {
  String listName = "";
  VoidCallback? onPressed;

  ListNavigation(String listName, VoidCallback? onPressed){
    this.listName = listName;
    this.onPressed = onPressed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 50,
            color: Colors.white70,
            child: Center(child: Text(listName),),
          ),
        ),
      ),
    );
  }
}
