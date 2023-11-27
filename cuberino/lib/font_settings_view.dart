import 'package:flutter/material.dart';
import 'app_settings.dart';
import 'main.dart';

class FontSettingsView extends StatefulWidget {
  @override
  _FontSettingsViewState createState() => _FontSettingsViewState();
}

class _FontSettingsViewState extends State<FontSettingsView> {
  final AppSettings _appSettings = AppSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Font Size',
                style: TextStyle(fontSize: _appSettings.fontSize),
              ),
              CheckboxListTile(
                title: Text('Small', style: TextStyle(fontSize: _appSettings.fontSize),),
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
                title: Text('Medium', style: TextStyle(fontSize: _appSettings.fontSize),),
                value: _appSettings.fontSize == 20.0,
                onChanged: (bool? value) {
                  if (value != null && value) {
                    setState(() {
                      _appSettings.fontSize = 20.0;
                    });
                  }
                },
              ),
              CheckboxListTile(
                title: Text('Large', style: TextStyle(fontSize: _appSettings.fontSize),),
                value: _appSettings.fontSize == 25.0,
                onChanged: (bool? value) {
                  if (value != null && value) {
                    setState(() {
                      _appSettings.fontSize = 25.0;
                    });
                  }
                },
              ),
            ],
          )
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
