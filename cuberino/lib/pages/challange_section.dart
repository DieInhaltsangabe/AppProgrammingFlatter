import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:cuberino/components/bottom_app_bar.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cuber/cuber.dart' as Cuber;
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

final AppSettings _appSettings = AppSettings();

class ChallangesSection extends StatefulWidget {
  const ChallangesSection({super.key});

  @override
  State<ChallangesSection> createState() => Challanges();
}

class Challanges extends State<ChallangesSection> {
  @override
  void initState() {
    super.initState();

    _loadData();
    _generateString();
  }

  List logs = [];

  int challangeId = 0;
  var challangeIdDay = [0, ""];
  int currentGridIndex = 0;
  var colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.white
  ];
  bool showNetwork = false;
  List challanges = [
    [Cuber.Cube.checkerboard, null, "Checkerboard"],
    [Cuber.Cube.anaconda, null, "Anaconda"],
    [Cuber.Cube.crossOne, null, "Cross One"],
    [Cuber.Cube.chickenFeet, null, "Chicken Feet"],
    [Cuber.Cube.cubeInCube, null, "Cube in Cube"],
    [Cuber.Cube.crossTwo, null, "Cross Two"],
    [Cuber.Cube.python, null, "Python"],
    [Cuber.Cube.sixTs, null, "6 Ts"],
    [Cuber.Cube.spiral, null, "Spiral"],
    [Cuber.Cube.wire, null, "Wire"],
    [Cuber.Cube.tetris, null, "Tetris"],
    [Cuber.Cube.twister, null, "Twister"],
  ];

  String solution = "";
  String inversedSolution = "";
  String zoom = _appSettings.cubeZoom;

  var grids = [
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.white, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ], // white
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.green, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ], // green
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.yellow, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ], // yellow
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.blue, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.red, Colors.orange]
    ], // blue
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.red, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.blue, Colors.green]
    ], // red
    [
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.grey, Colors.orange, Colors.grey],
      [Colors.grey, Colors.grey, Colors.grey],
      [Colors.blue, Colors.green]
    ], // orange
  ];

  HashMap<String, String> inverter = HashMap();

  void fillHashMap() {
    inverter["R"] = "R'";
    inverter["L"] = "L'";
    inverter["F"] = "F'";
    inverter["U"] = "U'";
    inverter["B"] = "B'";
    inverter["D"] = "D'";
    inverter["R'"] = "R";
    inverter["L'"] = "L";
    inverter["F'"] = "F";
    inverter["U'"] = "U";
    inverter["B'"] = "B";
    inverter["D'"] = "D";
  }

  String invertAlgorithm(Cuber.Solution sol) {
    String temp = sol.toString();
    List<String> moves = temp.split(' ');
    List<String> inversed = List.from(moves.reversed);
    fillHashMap();
    for (int i = 0; i < inversed.length; i++) {
      if (inverter.keys.contains(inversed[i])) {
        inversed[i] = inverter[inversed[i]] ?? inversed[i];
      }
    }
    print(inversed.join(' '));
    return inversed.join(' ');
  }

  void _generateString() async {
    final goal = challanges[challangeId][0];
    final sol = goal.solve(maxDepth: 25, timeout: Duration(seconds: 20));
    setState(() {
      solution = sol.toString();
      inversedSolution = invertAlgorithm(sol!);
    });
  }

  void switchGrid(int newIndex) {
    setState(() {
      currentGridIndex = newIndex;
    });
  }

  int currentColor = 0;

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String challangeString = prefs.getString("challanges") ?? "";
    var parsed = json.decode(challangeString);
    parsed[1] = DateTime.parse(parsed[1]);

    if (DateTime.now().isAfter(parsed[1])) {
      parsed[0] = parsed[0] + 1;
    }
    print(parsed);
    setState(() {
      challangeId = parsed[0];
    });
    print(parsed);
    _saveData();
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var today = DateTime.now();
    challangeIdDay[1] = DateTime(today.year, today.month, today.day);
    String saveListJSON = json.encode(challangeIdDay);
    prefs.setString("challanges", saveListJSON);
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
    double cubeDimFace = zoom == "Small" ? 50.0 : zoom == "Middle" ? 60.0 : 70.0;
    double cubeNetDim = zoom == "Small" ? 15.0 : zoom == "Middle" ? 20.0 : 25.0;
    Cuber.Cube currentChallange = challanges[challangeId][0];
    notateToGrid(currentChallange.definition);
    _generateString();
    return Scaffold(
      backgroundColor: _appSettings.background_color,
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.todaysChallenge, style: TextStyle(fontSize: AppSettings().fontSize, fontFamily: AppSettings().font)),
                const SizedBox(height: 4),
                Text(challanges[challangeId][2], style: TextStyle(fontSize: 50, fontFamily: AppSettings().font)),
                Center(child: Text(AppLocalizations.of(context)!.challangeInstruction, style: TextStyle(fontSize: AppSettings().fontSize, fontFamily: AppSettings().font ), textAlign: TextAlign.center,)),
                const SizedBox(height: 10),
                Container(
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
                            }});},
                            child: showNetwork ? Text(AppLocalizations.of(context)!.switchToCubeNet, style: TextStyle(fontSize: AppSettings().fontSize,fontFamily: AppSettings().font,
                                color: Theme.of(context).colorScheme.onSurface)) : Text(AppLocalizations.of(context)!.switchToFaceView, style: TextStyle(fontSize: AppSettings().fontSize, fontFamily: AppSettings().font,
                                color: Theme.of(context).colorScheme.onSurface)),
                          ),
                          SizedBox(
                              height: 5
                          ),
                          Container(
                              child: showNetwork ?
                              Column(
                                children: [
                                  Container(
                                    width: zoom == "Small" ? 30 : zoom == "Middle" ? 40 : 50,
                                    height: zoom == "Small" ? 30 : zoom == "Middle" ? 40 : 50,
                                    color: grids[currentGridIndex][3][0],
                                    child: Align(alignment: Alignment.center, child: Text("N", style: TextStyle(fontSize: 20))),
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
                                      width: zoom == "Small" ? 30 : zoom == "Middle" ? 40 : 50,
                                      height: zoom == "Small" ? 30 : zoom == "Middle" ? 40 : 50,
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
                              ) : Column(
                                children: [
                                  Column(
                                    children: [
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              child: Center(child: Text("U", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800))),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              child: Center(child: Text("L", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800))),
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
                                              child: Center(child: Text("F", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800))),
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
                                              child: Center(child: Text("R", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800))),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              child: Center(child: Text("D", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800))),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              child: Center(child: Text("B", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800))),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Left field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[4][1][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[4][1][1],
                                                child: Center(
                                                    child: Text("U",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800))),
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[4][2][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[4][2][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[3][0][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[3][0][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[3][0][2],
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][0][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][0][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][0][2],
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[1][0][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[1][0][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[3][1][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[3][1][1],
                                                child: Center(
                                                    child: Text("L",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800))),
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[3][1][2],
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][1][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][1][1],
                                                child: Center(
                                                    child: Text("F",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800))),
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][1][2],
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[1][1][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[1][1][1],
                                                child: Center(
                                                    child: Text("R",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800))),
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[3][2][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[3][2][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[3][2][2],
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][2][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][2][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[0][2][2],
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[1][2][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[1][2][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[5][0][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[5][0][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[5][1][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[5][1][1],
                                                child: Center(
                                                    child: Text("D",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800))),
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[5][2][0],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[5][2][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[2][2][2],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[2][2][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[2][1][2],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[2][1][1],
                                                child: Center(
                                                    child: Text("B",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800))),
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                width: 25,
                                                height: 25,
                                                color: grids[2][0][2],
                                              ),
                                              SizedBox(width: 5),
                                              // Center field
                                              Container(
                                                width: 25,
                                                height: 25,
                                                color: grids[2][0][1],
                                              ),
                                              SizedBox(width: 5),
                                              // Right field
                                              Container(
                                                width: 25,
                                                height: 25,
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
                    ],
                  )),
                ),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.showSolutions,
                      style: TextStyle(fontSize: AppSettings().fontSize, fontFamily: AppSettings().font,
                          color: Theme.of(context).colorScheme.onSurface)),
                  onPressed: () {
                    _showDialog(context, solution, inversedSolution);
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomMenu(true, true, true, false));
  }
}

void _showDialog(BuildContext context, String sol, String invers) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(AppLocalizations.of(context)!.solution,
            style: TextStyle(fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: AppSettings().fontSize,
          fontFamily: AppSettings().font)),
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text( AppLocalizations.of(context)!.challengeSolutionToPattern + ": " + sol,
                style: TextStyle(
                    color: Colors.teal.shade100,
                    fontWeight:
                    FontWeight.w600,
                    fontSize: _appSettings.fontSize,
                    fontFamily: AppSettings().font
                )
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(AppLocalizations.of(context)!.challengeSolutionToPattern + ": \n" + invers,
                style: TextStyle(
                  color:
                  Colors.teal.shade100,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: _appSettings.fontSize,
                  fontFamily: AppSettings().font,
                )
            ),
          )
        ]
      );
    }
  );
}
