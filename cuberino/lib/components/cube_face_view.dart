import 'package:cuberino/pages/tutorial.dart';
import 'package:cuberino/pages/tutorial_section.dart';
import 'package:flutter/material.dart';
import 'package:cuberino/main.dart';
import 'package:cuberino/pages/timer_section.dart';

import 'package:cuberino/pages/challange_section.dart';

class CubeFaceView extends StatefulWidget {

  CubeFaceView({required Row child}) {
  }

  @override
  Widget build(BuildContext context) {
    return CubeFaceView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
