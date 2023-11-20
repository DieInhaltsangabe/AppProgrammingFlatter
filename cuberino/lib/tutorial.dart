import 'package:cuberino/model/tutorial_repository.dart';
import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key, required this.parentId});

  final int parentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_sharp),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 4.0),
            child: Text(TutorialRepository.loadCaptionText(parentId)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                TutorialRepository.loadTutorial(parentId).pathToImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                  child: Text(TutorialRepository.loadTutorial(parentId)
                      .subsectionText))),
        ],
      ),
    );
  }
}
