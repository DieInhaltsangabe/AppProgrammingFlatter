import 'package:cuberino/model/tutorial_card_model.dart';
import 'package:cuberino/model/tutorial_repository.dart';
import 'package:cuberino/tutorialcard.dart';
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
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children:
            TutorialRepository.loadDataChild(parentId).map<Widget>((tutorial) {
          return TutorialCard(
              pathToImage: tutorial.pathToImage,
              captionText: tutorial.captionText,
              subsectionText: tutorial.subsectionText,
              id: tutorial.id,
              parentId: tutorial.parentId);
        }).toList(),
      ),
    );
  }
}
