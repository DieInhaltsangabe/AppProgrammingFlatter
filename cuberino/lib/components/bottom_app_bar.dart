import 'package:cuberino/pages/tutorial_section.dart';
import 'package:flutter/material.dart';
import 'package:cuberino/main.dart';
import 'package:cuberino/pages/timer_section.dart';

import 'package:cuberino/pages/challange_section.dart';

class BottomMenu extends StatefulWidget {
  /**
   * Flags which will indicate, which Section we are currently in-.
   */
  bool _timerSection = false;
  bool _mainScreen = false;
  bool _tutorialSection = false;
  bool _challanges = false;

  // constructor to initalize the attributes.
  BottomMenu(bool timerSection, bool mainScreen, bool tutorialSection,
      bool challanges) {
    _timerSection = timerSection;
    _mainScreen = mainScreen;
    _tutorialSection = tutorialSection;
    _challanges = challanges;
  }

  @override
  State<StatefulWidget> createState() => _BottomMenuWidget(
      _timerSection, _mainScreen, _tutorialSection, _challanges);
}

class _BottomMenuWidget extends State<BottomMenu> {
  bool _timerSection = false;
  bool _mainScreen = false;
  bool _tutorialSection = false;
  bool _challanges = false;

  // constructor
  _BottomMenuWidget(bool timerSection, bool mainScreen, bool tutorialSection,
      bool challanges) {
    _timerSection = timerSection;
    _mainScreen = mainScreen;
    _tutorialSection = tutorialSection;
    _challanges = challanges;
  }

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

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: !_timerSection ? Colors.grey : null,
            ),
            child: IconButton(
              icon: timer,
              onPressed: () {
                if (_timerSection) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TimerSection()));
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: !_mainScreen ? Colors.grey : null,
            ),
            child: IconButton(
              icon: mainCube,
              onPressed: () {
                if (_mainScreen) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cuberino()));
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: !_tutorialSection ? Colors.grey : null,
            ),
            child: IconButton(
              icon: tutorial,
              onPressed: () {
                if (_tutorialSection) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TutorialSection()));
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: !_challanges ? Colors.grey : null,
            ),
            child: IconButton(
                icon: challange,
                onPressed: () {
                  if (_challanges) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChallangesSection()));
                  }
                }),
          )
        ],
      ),
    );
  }
}
