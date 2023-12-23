import 'package:cuberino/app_settings.dart';
import 'package:cuberino/components/tutorialcard.dart';
import 'package:cuberino/model/tutorial_repository.dart';
import 'package:flutter/material.dart';

class TutorialDetail extends StatelessWidget {
  TutorialDetail({
    super.key,
    required this.parentId,
  });
  final int parentId;
  final _appSettings = AppSettings();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appSettings.background_color,
      appBar: AppBar(actions: []),
      body: Column(children: [
        Expanded(
            child: GridView.count(
          primary: false,
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: TutorialRepository.loadDataChild(parentId, context)
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
