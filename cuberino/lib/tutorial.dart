import 'package:cuberino/model/tutorial_repository.dart';
import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget {
  Tutorial({super.key, required this.parentId}) {
    tutorials =
        TutorialRepository.loadTutorial(parentId).map<Widget>((tutorial) {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              tutorial.pathToImage,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                child: Text(tutorial.subsectionText)))
      ];
    }).toList();
    tutorials?.insert(
        0,
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 4.0),
          child: Text(TutorialRepository.loadCaptionText(parentId)),
        ));
  }
  final int parentId;
  List<Widget>? tutorials;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: tutorials ?? [],
      ),
    );
  }
}
