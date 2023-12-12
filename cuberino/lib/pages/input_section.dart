import 'dart:ffi';

import 'package:cuberino/app_settings.dart';
import 'package:flutter/material.dart';

class InputSection extends StatefulWidget {
  const InputSection({super.key});

  @override
  InputSectionState createState() => InputSectionState();
}

class InputSectionState extends State<InputSection> {
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

  void switchGrid(int newIndex) {
    setState(() {
      currentGridIndex = newIndex;
    });
  }

  void submitCube() {
    var numberOfColors = {for (var color in colors) color: 0};
    for (var grid in grids) {
      for (var row in grid.getRange(0, 3)) {
        for (var field in row) {
          if (field != Colors.grey) {
            var value = numberOfColors[field]! + 1;
            numberOfColors[field] = value;
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Fehler'),
                  content: Text('Bitte alle Felder füllen'),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontSize: AppSettings().fontSize,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            return;
          }
        }
      }
    }
    for (var key in numberOfColors.keys) {
      print(numberOfColors[key]);
      if (numberOfColors[key] != 9) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Fehler'),
              content: Text('Felder sind falsch gefüllt'),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontSize: AppSettings().fontSize,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }
    Navigator.pop(context, buildCubeString());
  }

  String buildCubeString() {
    var stringArray = [];
    var counter = 0;
    var sortedGrid = [
      grids[4],
      grids[1],
      grids[0],
      grids[5],
      grids[3],
      grids[2]
    ];
    for (var grid in sortedGrid) {
      var cleanGrid = grid.getRange(0, 3).toList();
      for (var i = 0; i < cleanGrid.length; i++) {
        var row = cleanGrid[i];
        for (var k = 0; k < row.length; k++) {
          var field = row[k];
          String value = "";
          switch (field) {
            case Colors.red:
              value = "U";
              break;
            case Colors.green:
              value = "R";
              break;
            case Colors.white:
              value = "F";
              break;
            case Colors.orange:
              value = "D";
              break;
            case Colors.blue:
              value = "L";
              break;
            case Colors.yellow:
              value = "B";
              break;
          }
          stringArray.add(value);
        }
      }
    }
    return stringArray.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: []),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Add this line
            children: [
              const Text(''),
              const Text(
                  'Die mittlere Farbe gibt die jeweilige Seite an.'), //Vielleicht ein Never show this again screen mit hint davor
              const SizedBox(height: 10),
              Container(
                width: 50,
                height: 50,
                color: grids[currentGridIndex][3][0],
                child: Align(alignment: Alignment.center, child: Text("N", style: TextStyle(fontSize: 20))),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              Container(
                width: 50,
                height: 50,
                color: grids[currentGridIndex][3][1],
                  child: Align(alignment: Alignment.center, child: Text("S", style: TextStyle(fontSize: 20)))
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < colors.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentColor =
                              i; // Update activeColor when a color is tapped
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(boxShadow: [
                          if (i ==
                              currentColor) // Add boxShadow if the color is active
                            BoxShadow(
                              color: Theme.of(context).colorScheme.onSurface,
                              blurRadius: 5.0,
                              spreadRadius: 5.0,
                            ),
                        ], color: colors[i]),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              // Button
              ElevatedButton(
                onPressed: () {
                  submitCube();
                },
                child: Text(
                  'Solve',
                  style: TextStyle(
                      fontSize: AppSettings().fontSize,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              // Arrow buttons
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
          ),
        ));
  }
}
