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

class ChallangesSection extends StatefulWidget {
  const ChallangesSection({super.key});

  @override
  State<ChallangesSection> createState() => Challanges();
}

class Challanges extends State<ChallangesSection> {

  @override
  void initState() {
    super.initState();
    //_loadData();
    _generateString();
  }

  List logs = [];
  int challangeId = 3;
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

  List challangeSave = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]];

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

  String invertAlgorithm(Cuber.Solution sol){
    String temp = sol.toString();
    List<String> moves = temp.split(' ');
    List<String> inversed = List.from(moves.reversed);
    fillHashMap();
    for(int i = 0; i < inversed.length; i++){
      if(inverter.keys.contains(inversed[i])){
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

  _loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String challangeString = prefs.getString("challanges") ?? "";
    if (challangeString != ""){
      List temp = json.decode(challangeString);
      for(int i = 0; i < temp.length; i++){
        if(temp[i] != ""){
          temp[i] = DateTime.parse(temp[i]);
        }
      }
      challangeSave = temp;
    }
    int cID = 0;
    for(int i = 0; i < challangeSave.length; i++){
      if(challangeSave[i] == ""){
        cID = i;
        break;
      }
      else if(challangeSave[i].day == DateTime.now().day && challangeSave[i].month == DateTime.now().month && challangeSave[i].year == DateTime.now().year){
        cID = i;
        break;
      }
    }
  }

  _saveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    challangeSave[challangeId] = DateTime.now().toString();
    String saveListJSON = json.encode(challangeSave);
    prefs.setString("challanges", saveListJSON);
  }

  void notateToGrid(String notation){
    int notationIndex = 0;
    var sortedGrid = [ grids[4], grids[1], grids[0], grids[5], grids[3], grids[2]];
    for (int i = 0; i < 6; i++){
      for(int k = 0; k < 3; k++) {
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
      grids = [sortedGrid[2],  sortedGrid[1], sortedGrid[5], sortedGrid[4], sortedGrid[0], sortedGrid[3]];
    });

  }


  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Cuber.Cube currentChallange = challanges[challangeId][0];
    notateToGrid("UUUUUUFFFRRRRRRRRRFFDFFDFFDDDDDDDBBBLLLLLLLLLUBBUBBUBB");
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text("Todays Challange", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(challanges[challangeId][2], style: TextStyle(fontSize: 50)),
                Center(child: Text("Try to scramble your cube to get this pattern", style: TextStyle(fontSize: 20, ), textAlign: TextAlign.center,)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showNetwork = !showNetwork;
                    });
                  },
                  child: showNetwork ? Text("Switch Cube View") : Text("Switch to Network View"),
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
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][0][0],
                            ),
                            SizedBox(width: 10),
                            // Center field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][0][1],
                            ),
                            SizedBox(width: 10),
                            // Right field
                            Container(
                              width: 70,
                              height: 70,
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
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][1][0],
                            ),
                            SizedBox(width: 10),
                            // Center field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][1][1],
                            ),
                            SizedBox(width: 10),
                            // Right field
                            Container(
                              width: 70,
                              height: 70,
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
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][2][0],
                            ),
                            SizedBox(width: 10),
                            // Center field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][2][1],
                            ),
                            SizedBox(width: 10),
                            // Right field
                            Container(
                              width: 70,
                              height: 70,
                              color: grids[currentGridIndex][2][2],
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
                    ) : Column(
                      children: [
                        Column(
                          children: [
                            // Upper Face First Line
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Left field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][0][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][0][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][0][2],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            // Upper Face Middle Line
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Left field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][1][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][1][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][1][2],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            // Upper Face Bottom Line
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Left field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][2][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[4][2][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
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
                                    width: 15,
                                    height: 15,
                                    color: grids[3][0][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[3][0][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[3][0][2],
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][0][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][0][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][0][2],
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[1][0][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[1][0][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
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
                                    width: 15,
                                    height: 15,
                                    color: grids[3][1][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[3][1][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[3][1][2],
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][1][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][1][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][1][2],
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[1][1][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[1][1][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
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
                                    width: 15,
                                    height: 15,
                                    color: grids[3][2][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[3][2][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[3][2][2],
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][2][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][2][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[0][2][2],
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[1][2][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[1][2][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
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
                                    width: 15,
                                    height: 15,
                                    color: grids[5][0][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[5][0][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
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
                                    width: 15,
                                    height: 15,
                                    color: grids[5][1][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[5][1][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
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
                                    width: 15,
                                    height: 15,
                                    color: grids[5][2][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[5][2][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
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
                                    width: 15,
                                    height: 15,
                                    color: grids[2][0][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[2][0][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[2][0][2],
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
                                    width: 15,
                                    height: 15,
                                    color: grids[2][1][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[2][1][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[2][1][2],
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
                                    width: 15,
                                    height: 15,
                                    color: grids[2][2][0],
                                  ),
                                  SizedBox(width: 5),
                                  // Center field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[2][2][1],
                                  ),
                                  SizedBox(width: 5),
                                  // Right field
                                  Container(
                                    width: 15,
                                    height: 15,
                                    color: grids[2][2][2],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        )
                      ],
                    )
                ),
                ElevatedButton(
                  child: Text("Show Solutions"),
                  onPressed: () {
                    _showDialog(context, solution, inversedSolution);
                  },
                ),
              ],
            ),

          ),
      ),
      bottomNavigationBar: GestureDetector(
        child: BottomMenu(true, true, true, false),
        onTap: () => _saveData(),
      )
    );
  }
}

void _showDialog(BuildContext context, String sol, String invers){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Solution', style: TextStyle(color:
        Colors.teal.shade100,
            fontWeight:
            FontWeight.w600,
            fontSize: 20.0)),
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text("To get from a solved Cube to the pattern use this algorithm: " + sol,
                style: TextStyle(
                    color:
                    Colors.teal.shade100,
                    fontWeight:
                    FontWeight.w600,
                    fontSize: 20.0
                )
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text("To solve the cube back to normal, use this algorithm: \n" + invers,
                style: TextStyle(
                  color:
                  Colors.teal.shade100,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 20.0
                )
            ),
          )
        ]
      );
    }
  );
}