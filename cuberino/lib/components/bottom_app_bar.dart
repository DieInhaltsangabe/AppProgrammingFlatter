import 'package:cuberino/pages/tutorial.dart';
import 'package:cuberino/pages/tutorial_section.dart';
import 'package:flutter/material.dart';
import 'package:cuberino/main.dart';
import 'package:cuberino/pages/timer_section.dart';

import 'package:cuberino/pages/challange_section.dart';

class BottomMenu extends StatefulWidget {
  bool _timerSection = false;
  bool _mainScreen = false;
  bool _tutorialSection = false;
  bool _challanges = false;

  Widget timer = Icon(Icons.alarm);
  Widget mainCube = Image.asset('assets/rubik.png');
  Widget tutorial = Icon(Icons.menu_book);
  Widget challange = Icon(Icons.attractions);

  void resetIcons() {
    timer = Icon(Icons.alarm);
    mainCube = Image.asset('assets/rubik.png');
    tutorial = Icon(Icons.menu_book);
    challange = Icon(Icons.attractions);
  }

  BottomMenu(bool timerSection, bool mainScreen, bool tutorialSection, bool challanges) {
    _timerSection = timerSection;
    _mainScreen = mainScreen;
    _tutorialSection = tutorialSection;
    _challanges = challanges;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            IconButton(
              icon: timer,
              onPressed: () {
                if(_timerSection) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TimerSection()));
                  resetIcons();
                  setState(() {
                    timer = Icon(Icons.alarm_on);
                  }
                  });

              },
            ),
            IconButton(
              icon: mainCube,
              onPressed: () {
                if(_mainScreen) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cuberino()));
                }
              },
            ),
            IconButton(
              icon: tutorial,
              onPressed: () {
                if(_tutorialSection) {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => TutorialSection()));
                }
              },
            ),
            IconButton(
              icon: challange,
              onPressed: () {
                if(_challanges) {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => ChallangesSection()));
                }
              }
            )
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    createState() => CubeState();
  }
}
