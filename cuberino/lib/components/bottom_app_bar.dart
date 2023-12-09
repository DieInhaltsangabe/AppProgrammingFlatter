import 'package:cuberino/pages/tutorial.dart';
import 'package:cuberino/pages/tutorial_section.dart';
import 'package:flutter/material.dart';
import 'package:cuberino/main.dart';
import 'package:cuberino/pages/timer_section.dart';

import 'package:cuberino/pages/challange_section.dart';

class BottomMenu extends StatelessWidget {
  bool _timerSection = false;
  bool _mainScreen = false;
  bool _tutorialSection = false;
  bool _challanges = false;

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
          if (_timerSection)
            IconButton(
              icon: Icon(Icons.alarm),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TimerSection()));
              },
            ),
          if (_mainScreen)
            IconButton(
              icon: Image.asset('assets/rubik.png'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Cuberino()));
              },
            ),
          if (_tutorialSection)
            IconButton(
              icon: Icon(Icons.menu_book),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TutorialSection()));
              },
            ),
          if (_challanges)
            IconButton(
              icon: Icon(Icons.attractions),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChallangesSection()));
              }
            )
        ],
      ),
    );
  }
}
