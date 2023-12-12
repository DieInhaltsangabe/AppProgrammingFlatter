import 'package:cuberino/pages/input_section.dart';
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
            home: Cube(),
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme(
                    brightness: Brightness.dark,
                    primary: Color(0xFF252A29),
                    onPrimary: Color(0xFFFFFEFE),
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

class Cube extends StatefulWidget {
  const Cube({super.key});

  @override
  CubeState createState() => CubeState();
}

class CubeState extends State<Cube> {
  String cube = "";
  bool showNetwork = true;

  var grids = [
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.white, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ],
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.green, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ],
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.yellow, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ],
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.blue, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ],
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.red, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.blue, Colors.green]
    ],
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.orange, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.blue, Colors.green]
    ],
  ];

  int currentGridIndex = 0;
  int currentColor = 0;
  var colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.white
  ];

  void switchGrid(int newIndex) {
    setState(() {
      currentGridIndex = newIndex;
    });
  }

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
            child: Column(
          children: [
            Text(
              "Cuberino",
              style: TextStyle(
                  fontSize: AppSettings().fontSize,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showNetwork = !showNetwork;
                });
              },
              child: showNetwork ? Text("Switch Cube View") : Text("Switch to Network View"),
            ),
            SizedBox(
              height: 5
            ),
            Container(
              child: showNetwork ?
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        color: grids[currentGridIndex][3][0],
                        child: Align(alignment: Alignment.center, child: Text("N", style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Left field
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][0][0] = colors[currentColor];
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][0][0],
                            ),
                          ),
                          SizedBox(width: 10),
                          // Center field
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][0][1] = colors[currentColor];
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][0][1],
                            ),
                          ),
                          SizedBox(width: 10),
                          // Right field
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][0][2] = colors[currentColor];
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][0][2],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][1][0] = colors[currentColor];
                              });
                            },
                            child:
                            // Left field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][1][0],
                            ),
                          ),
                          SizedBox(width: 10),
                          // Center field
                          Container(
                            width: 70,
                            height: 70,
                            color: grids[currentGridIndex][1][1],
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][1][2] = colors[currentColor];
                              });
                            },
                            child:
                            // Right field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][1][2],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][2][0] = colors[currentColor];
                              });
                            },
                            child:
                            // Left field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][2][0],
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][2][1] = colors[currentColor];
                              });
                            },
                            child:
                            // Center field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][2][1],
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                grids[currentGridIndex][2][2] = colors[currentColor];
                              });
                            },
                            child:
                            // Right field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][2][2],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                          width: 50,
                          height: 50,
                          color: grids[currentGridIndex][3][1],
                          child: Align(alignment: Alignment.center, child: Text("S", style: TextStyle(fontSize: 20)))
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              switchGrid((currentGridIndex - 1) % grids.length);
                            },
                            icon: const Icon(Icons.arrow_left),
                          ),
                          IconButton(
                            onPressed: () {
                              switchGrid((currentGridIndex + 1) % grids.length);
                            },
                            icon: const Icon(Icons.arrow_right),
                          ),
                        ],
                      ),
                    ],
                  ) : Row()
            ),
            ElevatedButton(
              onPressed: () {
                var inputedCube = Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InputSection()));
                setState(() {
                  cube = inputedCube as String;
                });
              },
              child: Text(
                'Input',
                style: TextStyle(
                    fontSize: AppSettings().fontSize,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        )),
      ),
      bottomNavigationBar: BottomMenu(true, false, true, true),
    );
  }
}
