import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cuberino/l10n/l10n.dart';
import 'pages/settings_page.dart';
import 'components/bottom_app_bar.dart';
import 'app_settings.dart';

final AppSettings _appSettings = AppSettings();

void main() {
  runApp(Cuberino());
}

class Cuberino extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<void> _loadSettings = _appSettings.loadSettings();
    
    return FutureBuilder(
      future: _loadSettings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: MyHomePage(),
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme(
                    brightness: Brightness.dark,
                    primary: Color.fromARGB(255, 0, 128, 102),
                    onPrimary: Color.fromARGB(255, 100, 128, 0),
                    secondary: Color.fromARGB(255, 60, 0, 55),
                    onSecondary: Color.fromARGB(255, 60, 100, 55),
                    error: Color.fromARGB(255, 155, 108, 100),
                    onError: Color.fromARGB(255, 0, 255, 255),
                    background: Color(0xFF252A29),
                    onBackground: Color(0xFFFFFEFE),
                    surface: Color(0xFF42494E),
                    onSurface: Color(0xFFE8E7D8))),
            supportedLocales: L10n.all,
            locale: Locale(_appSettings.language),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void test() {}
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Container(
        color: _appSettings.background_color,
        child: Center(
          child: Text(
            'CUBERINO',
            style: TextStyle(fontSize: AppSettings().fontSize),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(true, false, true),
    );
  }
}
