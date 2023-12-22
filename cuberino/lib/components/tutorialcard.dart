import 'package:cuberino/components/tutorialdetail.dart';
import 'package:cuberino/pages/tutorial.dart';
import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  const TutorialCard({
    Key? key,
    required this.pathToImage,
    required this.captionText,
    required this.subsectionText,
    required this.id,
    this.parentId,
  }) : super(key: key);

  final String pathToImage;
  final String captionText;
  final String subsectionText;
  final int id;
  final int? parentId;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (parentId != null) {
                return Tutorial(
                  parentId: id,
                );
              }
              return TutorialDetail(
                parentId: id,
              );
            }),
          );
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  pathToImage,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(captionText),
                  const SizedBox(height: 8.0),
                  Text(subsectionText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
