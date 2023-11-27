import 'package:flutter/material.dart';
import 'package:cuberino/main.dart';
import 'package:cuberino/pages/timer_section.dart';
import 'package:cuberino/pages/tutorial_section.dart';

class BottomMenu extends StatelessWidget {

  bool _timerSection = false;
  bool _mainScreen = false;
  bool _tutorialSeciton = false;


  BottomMenu(bool timerSection, bool mainScreen, bool tutorialSection){
    _timerSection = timerSection;
    _mainScreen = mainScreen;
    _tutorialSeciton = tutorialSection;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(_timerSection)
            IconButton(
              icon: Icon(Icons.alarm),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                },
            ),
          if(_mainScreen)
            IconButton(
              icon: Image.asset('assets/rubik.png'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Cuberino()));
                },
            ),
          if(_tutorialSeciton)
            IconButton(
              icon: Icon(Icons.menu_book),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Tutorial()));
                },
            ),
        ],
      ),
    );
  }
}
