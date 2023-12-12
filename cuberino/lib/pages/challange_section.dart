import 'dart:async';
import 'package:cuberino/components/bottom_app_bar.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cuber/cuber.dart' as Cuber;
import 'dart:math';

class ChallangesSection extends StatefulWidget {
  const ChallangesSection({super.key});

  @override
  State<ChallangesSection> createState() => Challanges();
}

class Challanges extends State<ChallangesSection> {
  List logs = [];
  int challangeId = 0;
  int currentGridIndex = 0;
  var colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.white
  ];
  List challanges = [
    [Cuber.Cube.checkerboard, null],
    [Cuber.Cube.anaconda, null],
    [Cuber.Cube.crossOne, null],
    [Cuber.Cube.chickenFeet, null],
    [Cuber.Cube.cubeInCube, null],
    [Cuber.Cube.crossTwo, null],
    [Cuber.Cube.python, null],
    [Cuber.Cube.sixTs, null],
    [Cuber.Cube.spiral, null],
    [Cuber.Cube.wire, null],
    [Cuber.Cube.tetris, null],
    [Cuber.Cube.twister, null],
  ];

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

  void switchGrid(int newIndex) {
    setState(() {
      currentGridIndex = newIndex;
    });
  }

  void notationToGrid(){
    String notation = (challanges[challangeId][0] as Cuber.Cube).definition;
    var sortedGrid = [ grids[4], grids[1], grids[0], grids[5], grids[3], grids[2]];
    int cubicleCounter = 0;
    int lineCounter = 0;
    int gridCounter = 0;
    for(int i = 0; i < notation.length; i++){
      if(cubicleCounter == 3){
        cubicleCounter = 0;
        lineCounter++;
      }
      if(lineCounter == 3){
        lineCounter = 0;
        gridCounter++;
      }

      var newColor;
      switch (notation[i]) {
        case "U":
          newColor = colors[0];
          break;
        case "R":
          newColor = colors[4];
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
      sortedGrid[gridCounter][lineCounter][cubicleCounter] = newColor;
    }
    setState(() {
      grids = [
        sortedGrid[2], sortedGrid[1], sortedGrid[5], sortedGrid[4], sortedGrid[0], sortedGrid[3]
      ];
      print("DONE");
    });
  }

  int currentColor = 0;


  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    notationToGrid();
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
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

          ),
      ),
      bottomNavigationBar: BottomMenu(true, true, true, false),
    );
  }
}
