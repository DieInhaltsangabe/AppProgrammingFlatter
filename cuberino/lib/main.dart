import 'package:cuberino/pages/input_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cuberino/l10n/l10n.dart';
import 'pages/settings_page.dart';
import 'components/bottom_app_bar.dart';
import 'app_settings.dart';
import 'package:cuber/cuber.dart' as C;

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
}

class Cube extends StatefulWidget {
  const Cube({super.key});

  @override
  CubeState createState() => CubeState();
}

class CubeState extends State<Cube> {
  final temp = C.Cube.solved;
  String cube = "UUFUUFUUFRRRRRRRRRFFDFFDFFDDDBDDBDDBLLLLLLLLLBBUBBUBBU";
  bool showNetwork = false;
  String zoom = _appSettings.cubeZoom;

  @override
  void initState() {
    super.initState();
    final newCube = C.Cube.checkerboard;
    cube = newCube.definition;
  }

  void rotateCube(List<List<Color>> grid) {
    int N = grid.length - 1;

    // Transponieren der Matrix
    for (int i = 0; i < N; i++) {
      for (int j = i; j < N; j++) {
        Color temp = grid[j][i];
        grid[j][i] = grid[i][j];
        grid[i][j] = temp;
      }
    }

    // Umkehren der Zeilen
    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N / 2; j++) {
        Color temp = grid[i][j];
        grid[i][j] = grid[i][N - j - 1];
        grid[i][N - j - 1] = temp;
      }
    }
  }

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

  void notateToGrid(String notation) {
    int notationIndex = 0;
    var sortedGrid = [
      grids[4],
      grids[1],
      grids[0],
      grids[5],
      grids[3],
      grids[2]
    ];
    for (int i = 0; i < 6; i++) {
      for (int k = 0; k < 3; k++) {
        for (int j = 0; j < 3; j++) {
          var newColor;
          switch (notation[notationIndex]) {
            case "U":
              newColor = Colors.red;
              break;
            case "R":
              newColor = colors[3];
              break;
            case "F":
              newColor = colors[5];
              break;
            case "D":
              newColor = colors[1];
              break;
            case "L":
              newColor = colors[4];
              break;
            case "B":
              newColor = colors[2];
              break;
            default:
              newColor = Colors.black;
              break;
          }
          sortedGrid[i][k][j] = newColor;
          notationIndex++;
        }
      }
    }
    setState(() {
      grids = [
        sortedGrid[2],
        sortedGrid[1],
        sortedGrid[5],
        sortedGrid[4],
        sortedGrid[0],
        sortedGrid[3]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cube.length == 54) {
      notateToGrid(cube);
      //rotateCube(grids[2]);
      //rotateCube(grids[2]);
    }
    print(zoom);
    double cubeDimFace = zoom == "Small"
        ? 50.0
        : zoom == "Middle"
            ? 60.0
            : 70.0;
    double cubeNetDim = zoom == "Small"
        ? 15.0
        : zoom == "Middle"
            ? 20.0
            : 25.0;
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
            Container(
              color: _appSettings.background_color,
              child: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showNetwork = !showNetwork;
                        if (showNetwork) {
                          setState(() {
                            grids[4][3] = [Colors.yellow, Colors.white];
                            grids[5][3] = [Colors.white, Colors.yellow];
                          });
                        }
                      });
                    },
                    child: showNetwork
                        ? Text(AppLocalizations.of(context)!.switchToCubeNet,
                            style: TextStyle(
                                fontSize: AppSettings().fontSize,
                                fontFamily: AppSettings().font,
                                color: Theme.of(context).colorScheme.onSurface))
                        : Text(AppLocalizations.of(context)!.switchToFaceView,
                            style: TextStyle(
                                fontSize: AppSettings().fontSize,
                                fontFamily: AppSettings().font,
                                color:
                                    Theme.of(context).colorScheme.onSurface)),
                  ),
                  SizedBox(height: 5),
                  Container(
                      child: showNetwork
                          ? Column(
                              children: [
                                Container(
                                  width: zoom == "Small"
                                      ? 30
                                      : zoom == "Middle"
                                          ? 40
                                          : 50,
                                  height: zoom == "Small"
                                      ? 30
                                      : zoom == "Middle"
                                          ? 40
                                          : 50,
                                  color: grids[currentGridIndex][3][0],
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text("N",
                                          style: TextStyle(fontSize: 20))),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Left field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][0][0],
                                    ),
                                    SizedBox(width: 10),
                                    // Center field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][0][1],
                                    ),
                                    SizedBox(width: 10),
                                    // Right field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][0][2],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Left field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][1][0],
                                    ),
                                    SizedBox(width: 10),
                                    // Center field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][1][1],
                                      //child: Text("F", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20.0)),
                                    ),
                                    SizedBox(width: 10),
                                    // Right field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][1][2],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Left field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][2][0],
                                    ),
                                    SizedBox(width: 10),
                                    // Center field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][2][1],
                                    ),
                                    SizedBox(width: 10),
                                    // Right field
                                    Container(
                                      width: cubeDimFace,
                                      height: cubeDimFace,
                                      color: grids[currentGridIndex][2][2],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                    width: zoom == "Small"
                                        ? 30
                                        : zoom == "Middle"
                                            ? 40
                                            : 50,
                                    height: zoom == "Small"
                                        ? 30
                                        : zoom == "Middle"
                                            ? 40
                                            : 50,
                                    color: grids[currentGridIndex][3][1],
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("S",
                                            style: TextStyle(fontSize: 20)))),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        switchGrid((currentGridIndex - 1) %
                                            grids.length);
                                      },
                                      icon: const Icon(Icons.arrow_left),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        switchGrid((currentGridIndex + 1) %
                                            grids.length);
                                      },
                                      icon: const Icon(Icons.arrow_right),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Column(
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][0][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][0][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][0][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][1][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][1][1],
                                            child: Center(
                                                child: Text("U",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800))),
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][1][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][2][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][2][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[4][2][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][0][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][0][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][0][2],
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][0][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][0][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][0][2],
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][0][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][0][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][0][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][1][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][1][1],
                                            child: Center(
                                                child: Text("L",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800))),
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][1][2],
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][1][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][1][1],
                                            child: Center(
                                                child: Text("F",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800))),
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][1][2],
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][1][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][1][1],
                                            child: Center(
                                                child: Text("R",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800))),
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][1][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][2][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][2][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[3][2][2],
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][2][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][2][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[0][2][2],
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][2][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][2][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[1][2][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][0][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][0][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][0][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][1][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][1][1],
                                            child: Center(
                                                child: Text("D",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800))),
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][1][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][2][0],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][2][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[5][2][2],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][2][2],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][2][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][2][0],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][1][2],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][1][1],
                                            child: Center(
                                                child: Text("B",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800))),
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][1][0],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Left field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][0][2],
                                          ),
                                          SizedBox(width: 5),
                                          // Center field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][0][1],
                                          ),
                                          SizedBox(width: 5),
                                          // Right field
                                          Container(
                                            width: cubeNetDim,
                                            height: cubeNetDim,
                                            color: grids[2][0][0],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                )
                              ],
                            )),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        var inputedCube = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputSection()));
                        setState(() {
                          if (inputedCube != Null) {
                            cube = inputedCube as String;
                          }
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.input,
                        style: TextStyle(
                            fontSize: AppSettings().fontSize,
                            fontFamily: AppSettings().font,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final cube1 = C.Cube.from(cube);
                        print(cube1.definition);
                        final solution = await cube1.solve(
                            maxDepth: 25, timeout: Duration(seconds: 20));
                        print(solution);
                        setState(() {
                          print(solution);
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.solve,
                        style: TextStyle(
                            fontSize: AppSettings().fontSize,
                            fontFamily: AppSettings().font,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                ],
              )),
            )
          ],
        )),
      ),
      bottomNavigationBar: BottomMenu(true, false, true, true),
    );
  }
}
