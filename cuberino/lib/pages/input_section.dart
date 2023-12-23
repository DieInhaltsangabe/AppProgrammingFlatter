import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter/material.dart';

class InputSection extends StatefulWidget {
  const InputSection({super.key});

  @override
  InputSectionState createState() => InputSectionState();
}

class InputSectionState extends State<InputSection> {
  final _appSettings = AppSettings();
  TextEditingController _textFieldController = TextEditingController();
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

  /**
   * Method which will take current cube grid oritnetation and formation, to generate the cube notation string to represent this cube
   */
  String buildCubeString() {
    rotateCube(grids[4]);
    rotateCube(grids[4]);
    rotateCube(grids[4]);
    rotateCube(grids[5]);
    rotateCube(grids[5]);
    rotateCube(grids[5]);

    var stringArray = [];
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

  /**
   * Switches the rendered face of the cube.
   */
  void switchGrid(int newIndex) {
    setState(() {
      currentGridIndex = newIndex;
    });
  }

  /**
   * Rotate a single face from the cube by 90 degrees, to fix a conversion error we faced.
   */
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

  /**
   * Check if the Cube Input has enough occurances of each color (exactly 9)
   */
  bool ValidateCube() {
    var numberOfColors = {for (var color in colors) color: 0};
    for (var grid in grids) {
      for (var row in grid.getRange(0, 3)) {
        for (var field in row) {
          if (field != Colors.grey) {
            var value = numberOfColors[field]! + 1;
            numberOfColors[field] = value;
          } else {
            return false;
          }
        }
      }
    }
    for (var key in numberOfColors.keys) {
      print(numberOfColors[key]);
      if (numberOfColors[key] != 9) {
        return false;
      }
    }
    return true;
  }

  /**
   * When input is done, this method is called to check if it i filled up correctly.
   * If not a dialog will be shown. If it is, it will return to Main View
   */
  String submitCube() {
    if (!ValidateCube()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.error,
                style: TextStyle(
                    fontSize: AppSettings().fontSize,
                    fontFamily: AppSettings().font)),
            content: Text(AppLocalizations.of(context)!.fieldNotCorrectFilled,
                style: TextStyle(
                    fontSize: AppSettings().fontSize,
                    fontFamily: AppSettings().font)),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.errorAccept,
                  style: TextStyle(
                      fontSize: AppSettings().fontSize,
                      fontFamily: AppSettings().font,
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
      return "";
    } else {
      return buildCubeString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: []),
        backgroundColor: _appSettings.background_color,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Add this line
            children: [
              Text(AppLocalizations.of(context)!.middleSide,
                  style: TextStyle(
                      fontSize: AppSettings().fontSize,
                      fontFamily: AppSettings()
                          .font)), //Vielleicht ein Never show this again screen mit hint davor
              const SizedBox(height: 10),
              Container(
                width: 50,
                height: 50,
                color: grids[currentGridIndex][3][0],
                child: Align(
                    alignment: Alignment.center,
                    child: Text(AppLocalizations.of(context)!.north,
                        style: TextStyle(
                            fontSize: AppSettings().fontSize,
                            fontFamily: AppSettings().font))),
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
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context)!.south,
                          style: TextStyle(
                              fontSize: AppSettings().fontSize,
                              fontFamily: AppSettings().font)))),
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
                  var submit = submitCube();
                  if (submit != "") {
                    Navigator.pop(context, submit);
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.solve,
                  style: TextStyle(
                    fontSize: AppSettings().fontSize,
                    fontFamily: AppSettings().font,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Button
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (ValidateCube()) {
                        _textFieldController.text = submitCube();
                      }
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.import,
                            style: TextStyle(
                                fontSize: AppSettings().fontSize,
                                fontFamily: AppSettings().font)),
                        content: TextField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.cubeInput,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!.errorAccept,
                              style: TextStyle(
                                fontSize: AppSettings().fontSize,
                                fontFamily: AppSettings().font,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pop(context, _textFieldController.text);
                            },
                          ),
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!.copy,
                              style: TextStyle(
                                fontSize: AppSettings().fontSize,
                                fontFamily: AppSettings().font,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: _textFieldController.text));
                              Navigator.of(context).pop();
                              Navigator.pop(context, _textFieldController.text);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.import,
                  style: TextStyle(
                    fontSize: AppSettings().fontSize,
                    fontFamily: AppSettings().font,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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
