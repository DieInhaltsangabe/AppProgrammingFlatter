import 'dart:async';
import 'dart:convert';
import 'package:cuberino/components/bottom_app_bar.dart';
import 'package:cuberino/app_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class TimerSection extends StatefulWidget {
  const TimerSection({super.key});

  @override
  State<TimerSection> createState() => TimerApp();
}

class TimerApp extends State<TimerSection> {
  static const String _logKey = "timeLogs";
  final _appSettings = AppSettings();
  List logs = [];

  Color background = Color(0xFF1C2757);
  Color secondBackground = Color(0xFF323F68);
  String timerInstruction = "";
  String prText = " -";
  String avgText = " -";

  int seconds = 0, minutes = 0, milliseconds = 0;
  String digitSeconds = "00", digitMinutes = "00", digitMilliseconds = "00";
  int prMin = 0, prSec = 0, prMil = 0;
  Timer? timer;
  bool started = false;
  bool hideLog = false;

  String currentScramble = "";

  bool holding = false;

  String _formatTwoDigits(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  Future<void> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    var temp = json.decode(prefs.getString(_logKey)!);
    setState((){
      logs = temp;
    });
  }

  Future<void> saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    var s = json.encode(logs);
    await prefs.setString(_logKey, s);
  }

  void calculateAverageAndPR() {
    saveLogs();
    bool newBest = false;

    if (logs.length == 0) {
      setState(() {
        started = false;
        prText = " -";
        avgText = " -";
      });
      return;
    }
    double avgSumMilliseconds = 0.0;

    for (int i = 0; i < logs.length; i++) {
      List<String> current = logs[i][0].split(':');
      // min kleiner
      if ((prMin > int.parse(current[0]) ||
              prMin >= int.parse(current[0]) && prSec > int.parse(current[1]) ||
              prMin >= int.parse(current[0]) &&
                  prSec >= int.parse(current[1]) &&
                  prMil > int.parse(current[2])) ||
          logs.length == 1) {
        prMin = int.parse(current[0]);
        prSec = int.parse(current[1]);
        prMil = int.parse(current[2]);
        if (prMil >= 100 && prMil <= 999) {
          prMil = ((prMil / 100).round()) % 100;
        }
        newBest = true;
      }
      double secondToMillisecond = double.parse(current[1]) * 1000;
      double minuteToMillisecond = double.parse(current[0]) * 1000 * 60;
      avgSumMilliseconds = avgSumMilliseconds +
          secondToMillisecond +
          minuteToMillisecond +
          double.parse(current[2]);
    }

    avgSumMilliseconds = avgSumMilliseconds / logs.length;

    int minutes = (avgSumMilliseconds ~/ (1000 * 60)) % 60;
    avgSumMilliseconds = avgSumMilliseconds - (minutes * (60000));
    int seconds = (avgSumMilliseconds ~/ 1000) % 60;
    avgSumMilliseconds = avgSumMilliseconds - (seconds * 1000);
    int avg = avgSumMilliseconds.round();
    String tempAVG;
    if (avg >= 100) {
      avg = ((avg / 100).round()) % 100;
      tempAVG = avg.toString();
    } else if (avg < 100 && avg >= 10) {
      tempAVG = avg.toString();
    } else {
      tempAVG = "0" + avg.toString();
    }

    String formattedTimeAVG = '$minutes:${_formatTwoDigits(seconds)}:$tempAVG';

    setState(() {
      if (newBest || prText == " -") {
        prText = " " +
            (prMin.toString().length == 2
                ? prMin.toString()
                : "0" + prMin.toString()) +
            ":" +
            (prSec.toString().length == 2
                ? prSec.toString()
                : "0" + prSec.toString()) +
            ":" +
            _formatTwoDigits(prMil);
      }

      avgText = " " + formattedTimeAVG;
    });
  }

  // stop timer func
  void stopTimer() {
    timer!.cancel();
    saveLogs();
    setState(() {
      started = false;
    });
  }

  // reset
  void resetTimer() {
    timer!.cancel();
    setState(() {
      milliseconds = 0;
      seconds = 0;
      minutes = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitMilliseconds = "00";

      started = false;
    });
  }

  void startTimer() {
    started = true;
    digitSeconds = "00";
    digitMinutes = "00";
    digitMilliseconds = "00";
    seconds = 0;
    minutes = 0;
    milliseconds = 0;
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      int localMilliseconds = milliseconds + 1;
      int localSeconds = seconds;
      int localMinutes = minutes;

      if (localMilliseconds > 99) {
        if (localSeconds > 59) {
          localMinutes++;
          localSeconds = 0;
        } else {
          localSeconds++;
          localMilliseconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        milliseconds = localMilliseconds;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitMilliseconds =
            (milliseconds >= 10) ? "$milliseconds" : "0$milliseconds";
      });
    });
  }

  void getScramble() {
    const moves = ["L", "R", "F", "D", "B", "U"];
    Map<String, String> inverts = {
      "L": "L'",
      "R": "R'",
      "F": "F'",
      "D": "D'",
      "B": "B'",
      "U": "U'",
      "2L": "2L",
      "2R": "2R",
      "2B": "2B",
      "2D": "2D",
      "2F": "2F",
      "2U": "2U",
      "R'": "R",
      "L'": "L",
      "U'": "U",
      "B'": "B",
      "F'": "F",
      "D'": "D",
    };
    var random = Random();
    var scramble = [];
    var len = scramble.length;
    // Single, Double, Revert
    while (scramble.length < 20) {
      var move = random.nextInt(moves.length);
      var type = random.nextInt(3);
      switch (type) {
        case 0: //single thingie
          if (scramble.isEmpty) {
            scramble.add(moves[move]);
          } else if (scramble[scramble.length - 1] == moves[move]) {
            scramble[scramble.length - 1] = "2${moves[move]}";
          } else if (scramble[scramble.length - 1] == inverts[moves[move]]) {
            break;
          } else if (scramble[scramble.length - 1] == "2${moves[move]}") {
            break;
          } else {
            scramble.add(moves[move]);
          }
          break;
        case 1: //double move
          if (scramble.isEmpty) {
            scramble.add("2${moves[move]}");
          } else if ((scramble[scramble.length - 1] == ("2${moves[move]}")) ||
              (scramble[scramble.length - 1] == inverts["2${moves[move]}"])) {
            break;
          } else if (scramble[scramble.length - 1] == moves[move] ||
              scramble[scramble.length - 1] == inverts[move]) {
            break;
          } else {
            scramble.add("2${moves[move]}");
          }
          break;
        case 2: //invers
          if (scramble.isEmpty) {
            scramble.add("${moves[move]}'");
          } else if (scramble[scramble.length - 1] == "${moves[move]}'") {
            scramble[scramble.length - 1] = "2${moves[move]}";
          } else if (scramble[scramble.length - 1] == moves[move] ||
              scramble[scramble.length - 1] == "2${moves[move]}") {
            break;
          } else {
            scramble.add("${moves[move]}'");
          }
          break;
        default:
          break;
      }
    }
    setState(() {
      currentScramble = scramble.join("  ");
    });
  }

  double getHeight() {
    if(logs.length == 0){
      return 75;
    }
    else if(logs.length < 10){
      return (75+50*(logs.length-1)).toDouble();
    }
    else{
      return 300;
    }
  }

  String getFormattedDate(String date) {
    List<String> data = date.split("-");
    return "${data[2]}.${data[1]}.${data[0]}";
  }

  @override
  Widget build(BuildContext context){
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    loadLogs();
    calculateAverageAndPR();
    return Scaffold(
      backgroundColor: _appSettings.background_color,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      visible: !started,
                      child: Container(
                        height: 165.0,
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.zero,
                        decoration: BoxDecoration(
                          color: secondBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 0, left: 10),
                                child: Text(
                                  currentScramble,
                                  style: const TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      visible: !started,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    getScramble();
                                  },

                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .generateScramble,
                                    style: TextStyle(color: Colors.white, fontSize: AppSettings().fontSize),
                                  )),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        "$digitMinutes:$digitSeconds:$digitMilliseconds",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 82.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.best + prText + "\n" + AppLocalizations.of(context)!.avg + avgText,
                        style: TextStyle(
                          color: Colors.teal.shade100,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSettings().fontSize,
                        ),
                      ),
                    ),
                    Text(
                      timerInstruction.length == 0 ? AppLocalizations.of(context)!.timerOff : timerInstruction,
                      style: TextStyle(
                        color: Colors.teal.shade100,
                        fontWeight: FontWeight.w600,
                          fontSize: AppSettings().fontSize,
                      ),
                    ),
                    Listener(
                      onPointerDown: (event) {
                        holding = true;
                        if (background == Color(0xFF1C2757)) {
                          Timer.periodic(Duration(milliseconds: 1500), (timer) {
                            setState(() {
                              if (!started && holding) {
                                background = Colors.green;
                                secondBackground = Colors.lightGreen;
                                timerInstruction =
                                    AppLocalizations.of(context)!.timerArmed;
                                hideLog = true;
                              }
                              timer.cancel();
                            });
                          });
                        } else {
                          timer!.cancel();
                          started = false;
                          background = Color(0xFF1C2757);
                          secondBackground = Color(0xFF323F68);
                          timerInstruction =
                              AppLocalizations.of(context)!.timerOff;

                          String time = digitMinutes +
                              ":" +
                              digitSeconds +
                              ":" +
                              digitMilliseconds;
                          String date = DateTime.now().day.toString() +
                              "." +
                              DateTime.now().month.toString() +
                              "." +
                              DateTime.now().year.toString();
                          logs.add([time, date]);
                          calculateAverageAndPR();
                          hideLog = false;
                        }
                      },
                      onPointerUp: (event) {
                        holding = false;
                        if (background == Colors.green) {
                          startTimer();
                        }
                        else{
                          saveLogs();
                        }
                      },
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          color: secondBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      visible: !started || !hideLog,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child : ElevatedButton(
                            child: Text(AppLocalizations.of(context)!.showLogs, style: TextStyle(fontSize: AppSettings().fontSize)),
                            onPressed: () {
                              showDialog(context: context,
                                  builder: (context) => StatefulBuilder(
                                    builder: (context, setState) {
                                      return SimpleDialog(
                                        title: const Text("Logs"),
                                        contentPadding: const EdgeInsets.all(10.0),
                                        children: [
                                          SizedBox(
                                              height: logs.length < 9 ? null : 500,
                                              width: double.maxFinite,
                                              child: logs.isNotEmpty ? ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: logs.length,
                                                  itemBuilder: (context, index) {
                                                    return Card(
                                                      color: secondBackground,
                                                      child: Padding(
                                                          padding: EdgeInsets.only(top: 2),
                                                          child: Row(children: [
                                                            Column(children: [
                                                              Padding(
                                                                padding: EdgeInsets.only(left: 5),
                                                                child: Text(
                                                                  logs[index][0]+" |",
                                                                  style: TextStyle(
                                                                    color: Colors.teal.shade100,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: (15),
                                                                  ),
                                                                ),
                                                              )
                                                            ]),
                                                            Column(children: [
                                                              Padding(
                                                                padding: EdgeInsets.only(left: 2),
                                                                child: Text(
                                                                  logs[index][1]+" |",
                                                                  style: TextStyle(
                                                                    color: Colors.teal.shade100,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: (15),
                                                                  ),
                                                                ),
                                                              )
                                                            ]),
                                                            Column(children: [
                                                              RawMaterialButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      logs.removeAt(index);
                                                                      calculateAverageAndPR();
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      "X",
                                                                      style: TextStyle(
                                                                          color: Colors.teal.shade100,
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 15)),
                                                                ),

                                                            ]),
                                                          ])),
                                                    );
                                                  }) : Center(child: Text(AppLocalizations.of(context)!.emptyLogs,
                                                  style: TextStyle(
                                                    fontSize: AppSettings().fontSize,
                                              )))),
                                        ]
                                      );
                                    }
                                  ));
                            },
                          ),
                          ),
                        ],
                      ),
                    ),
                  ]))),
      bottomNavigationBar: BottomMenu(false, true, true, true),
    );
  }
}
