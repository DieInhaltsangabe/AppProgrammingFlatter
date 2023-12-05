import 'package:cuberino/components/bottom_app_bar.dart';
import 'package:cuberino/model/tutorial_card_model.dart';
import 'package:cuberino/model/tutorial_repository.dart';
import 'package:flutter/material.dart';

import '../components/tutorialcard.dart';

class TutorialSection extends StatelessWidget {
  TutorialSection({super.key});
  final List<TutorialCardModel> tutorials = TutorialRepository.loadDataParent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(true, true, false),
      body: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: tutorials.map((tutorial) {
            return TutorialCard(
                pathToImage: tutorial.pathToImage,
                captionText: tutorial.captionText,
                subsectionText: tutorial.subsectionText,
                id: tutorial.id,
                parentId: tutorial.parentId);
          }).toList()),
    );
  }
}
