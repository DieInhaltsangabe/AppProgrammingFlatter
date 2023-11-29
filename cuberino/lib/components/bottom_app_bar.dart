import 'package:cuberino/pages/tutorial.dart';
import 'package:cuberino/pages/tutorial_section.dart';
import 'package:flutter/material.dart';
import 'package:cuberino/main.dart';
import 'package:cuberino/pages/timer_section.dart';

class BottomMenu extends StatelessWidget {
  bool _timerSection = false;
  bool _mainScreen = false;
  bool _tutorialSection = false;

  BottomMenu(bool timerSection, bool mainScreen, bool tutorialSection) {
    _timerSection = timerSection;
    _mainScreen = mainScreen;
    _tutorialSection = tutorialSection;
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
        ],
      ),
    );
  }
}
