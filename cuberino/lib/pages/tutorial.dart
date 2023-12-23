import 'package:cuberino/model/tutorial_repository.dart';
import 'package:flutter/material.dart';

import '../app_settings.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key, required this.parentId});

  final int parentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSettings().background_color,
      appBar: AppBar(actions: []),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 4.0),
            child: Text(TutorialRepository.loadCaptionText(parentId, context),
                style: TextStyle(
                    fontSize: AppSettings().fontSize,
                    fontFamily: AppSettings().font)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                TutorialRepository.loadTutorial(parentId, context).pathToImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
              child: SingleChildScrollView(
                child: Text(
                  TutorialRepository.loadTutorial(parentId, context)
                      .subsectionText,
                  style: TextStyle(
                      fontSize: AppSettings().fontSize,
                      fontFamily: AppSettings().font),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
