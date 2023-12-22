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
  String timerInstruction =
      ""; // The holder of the message, to tell the user how to proceed to start and stop the timer.
  String prText = " -"; // PLaceholder for the Personal Best time
  String avgText = " -"; // Place holder for current average time.

  int seconds = 0,
      minutes = 0,
      milliseconds = 0; // Integer representations of seconds, minutes and ms
  String digitSeconds = "00",
      digitMinutes = "00",
      digitMilliseconds =
          "00"; // String representation of seconds, minutes, and ms.
  int prMin = 0,
      prSec = 0,
      prMil =
          0; // integer representation of personal best time in minutes, seconds and ms.
  Timer? timer;
  bool started =
      false; // A flag, which indicates, if the timer has been started or not
  bool hideLog =
      false; // A flag which indicates, if the timer log button should be hidden. (Hides when timer started)

  String currentScramble = ""; // deprecated?

  bool holding =
      false; // A flag which indicates, if the user is holding down on the timer start area.

  /**
   * Format two digit integer and one digit integers into stanardized two digit string. 
   */
  String _formatTwoDigits(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  /**
   * A method will will access the shared prefernces of the mobile phone, to check if there were already any time logs saved.
   */
  Future<void> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    var temp = json.decode(prefs.getString(_logKey)!);
    setState(() {
      logs = temp;
    });
  }

  /**
   * A method which will save the current time logs, if it has changed at all.
   */
  Future<void> saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    var s = json.encode(logs);
    await prefs.setString(_logKey, s);
  }

  /**
   * A method which will calulcate the average time and the best time so far with the help of the logs. 
   */
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

  // Stop Timer Method
  void stopTimer() {
    timer!.cancel();
    saveLogs();
    setState(() {
      started = false;
    });
  }

  // Reset Timer Method
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

  // Start timer method
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

  /**
   * A method which will generate a random scramble to time yourself on. The random scramble will habe 20 Moves
   */
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

  /**
   * A method which will get the length of the logs an adjust the height. 
   */
  double getHeight() {
    if (logs.length == 0) {
      return 75;
    } else if (logs.length < 10) {
      return (75 + 50 * (logs.length - 1)).toDouble();
    } else {
      return 300;
    }
  }

  /**
   * A method which will return datetime string, to a string DD:MM:YYYY format.
   */
  String getFormattedDate(String date) {
    List<String> data = date.split("-");
    return "${data[2]}.${data[1]}.${data[0]}";
  }

  @override
  Widget build(BuildContext context) {
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
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSettings().fontSize,
                                        fontFamily: AppSettings().font),
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
                        AppLocalizations.of(context)!.best +
                            prText +
                            "\n" +
                            AppLocalizations.of(context)!.avg +
                            avgText,
                        style: TextStyle(
                          color: Colors.teal.shade100,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSettings().fontSize,
                          fontFamily: AppSettings().font,
                        ),
                      ),
                    ),
                    Text(
                      timerInstruction.length == 0
                          ? AppLocalizations.of(context)!.timerOff
                          : timerInstruction,
                      style: TextStyle(
                        color: Colors.teal.shade100,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSettings().fontSize,
                        fontFamily: AppSettings().font,
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
                        } else {
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
                            child: ElevatedButton(
                              child: Text(
                                  AppLocalizations.of(context)!.showLogs,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppSettings().fontSize,
                                      fontFamily: AppSettings().font)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder:
                                        (context) => StatefulBuilder(
                                                builder: (context, setState) {
                                              return SimpleDialog(
                                                  title: const Text("Logs"),
                                                  contentPadding:
                                                      const EdgeInsets.all(
                                                          10.0),
                                                  children: [
                                                    SizedBox(
                                                        height: logs.length < 9
                                                            ? null
                                                            : 500,
                                                        width: double.maxFinite,
                                                        child: logs.isNotEmpty
                                                            ? ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    logs.length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Card(
                                                                    color:
                                                                        secondBackground,
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(top: 2),
                                                                        child: Row(children: [
                                                                          Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 5),
                                                                                  child: Text(
                                                                                    logs[index][0] + " |",
                                                                                    style: TextStyle(
                                                                                      color: Colors.teal.shade100,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: (15),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ]),
                                                                          Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(left: 2),
                                                                                  child: Text(
                                                                                    logs[index][1] + " |",
                                                                                    style: TextStyle(
                                                                                      color: Colors.teal.shade100,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: (15),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ]),
                                                                          Column(
                                                                              children: [
                                                                                RawMaterialButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      logs.removeAt(index);
                                                                                      calculateAverageAndPR();
                                                                                    });
                                                                                  },
                                                                                  child: Text("X", style: TextStyle(color: Colors.teal.shade100, fontWeight: FontWeight.w600, fontSize: 15)),
                                                                                ),
                                                                              ]),
                                                                        ])),
                                                                  );
                                                                })
                                                            : Center(
                                                                child: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .emptyLogs,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          AppSettings()
                                                                              .fontSize,
                                                                      fontFamily:
                                                                          AppSettings()
                                                                              .font,
                                                                    )))),
                                                  ]);
                                            }));
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
