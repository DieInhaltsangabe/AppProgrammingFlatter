import 'package:cuberino/components/tutorialcard.dart';
import 'package:cuberino/model/tutorial_repository.dart';
import 'package:flutter/material.dart';

class TutorialDetail extends StatelessWidget {
  const TutorialDetail({
    super.key,
    required this.parentId,
  });
  final int parentId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []),
      body: Column(children: [
        Expanded(
            child: GridView.count(
          primary: false,
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: TutorialRepository.loadDataChild(parentId)
              .map<Widget>((tutorial) {
            return TutorialCard(
                pathToImage: tutorial.pathToImage,
                captionText: tutorial.captionText,
                subsectionText: tutorial.subsectionText,
                id: tutorial.id,
                parentId: tutorial.parentId);
          }).toList(),
        ))
      ]),
    );
  }
}
