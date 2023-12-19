import 'package:cuberino/model/tutorial_card_model.dart';
import 'package:cuberino/model/tutorial_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialRepository {
  static loadDataParent(BuildContext context) {
    return [
      TutorialCardModel(
          id: 1,
          pathToImage: 'assets/starter.jpeg',
          captionText: AppLocalizations.of(context)!.starterLevel,
          subsectionText: AppLocalizations.of(context)!.starterLevelText),
      TutorialCardModel(
          id: 2,
          pathToImage: 'assets/advanced.jpeg',
          captionText: AppLocalizations.of(context)!.advancedLevel,
          subsectionText: AppLocalizations.of(context)!.advancedLevelText),
      TutorialCardModel(
          id: 3,
          pathToImage: 'assets/expert.jpeg',
          captionText: AppLocalizations.of(context)!.expertLevel,
          subsectionText: AppLocalizations.of(context)!.expertLevelText),
      TutorialCardModel(
          id: 4,
          pathToImage: 'assets/genius.jpg',
          captionText: AppLocalizations.of(context)!.geniusLevel,
          subsectionText: AppLocalizations.of(context)!.geniusLevelText),
    ];
  }

  static loadDataChild(int id, BuildContext context) {
    var tutorials = [
      TutorialCardModel(
          id: 5,
          pathToImage: 'assets/tutorialwhitecross.jpeg',
          captionText: AppLocalizations.of(context)!.whiteCross,
          subsectionText: AppLocalizations.of(context)!.firstStep,
          parentId: 1),
      TutorialCardModel(
          id: 7,
          pathToImage: 'assets/whiteSide.png',
          captionText: AppLocalizations.of(context)!.whiteSide,
          subsectionText: AppLocalizations.of(context)!.secondStep,
          parentId: 1),
      TutorialCardModel(
          id: 8,
          pathToImage: 'assets/middleLayer.png',
          captionText: AppLocalizations.of(context)!.middleLayer,
          subsectionText: AppLocalizations.of(context)!.thirdStep,
          parentId: 1),
      TutorialCardModel(
          id: 9,
          pathToImage: 'assets/topCross.png',
          captionText: AppLocalizations.of(context)!.topCross,
          subsectionText: AppLocalizations.of(context)!.fourthStep,
          parentId: 1),
      TutorialCardModel(
          id: 11,
          pathToImage: 'assets/changeEdges.png',
          captionText: AppLocalizations.of(context)!.changeEdges,
          subsectionText: AppLocalizations.of(context)!.fifthStep,
          parentId: 1),
      TutorialCardModel(
          id: 12,
          pathToImage: 'assets/changeCorners.png',
          captionText: AppLocalizations.of(context)!.changeCorners,
          subsectionText: AppLocalizations.of(context)!.sixthStep,
          parentId: 1),
      TutorialCardModel(
          id: 13,
          pathToImage: 'assets/turnCorners.png',
          captionText: AppLocalizations.of(context)!.turnCorners,
          subsectionText: AppLocalizations.of(context)!.seventhStep,
          parentId: 1),
      TutorialCardModel(
          id: 19,
          pathToImage: 'assets/notation.png',
          captionText: AppLocalizations.of(context)!.notation,
          subsectionText: AppLocalizations.of(context)!.understanding,
          parentId: 1),
      TutorialCardModel(
          id: 21,
          pathToImage: 'assets/unknow.jpg',
          captionText: AppLocalizations.of(context)!.unknown,
          subsectionText: AppLocalizations.of(context)!.unknown,
          parentId: 2),
      TutorialCardModel(
          id: 22,
          pathToImage: 'assets/unknow.jpg',
          captionText: AppLocalizations.of(context)!.unknown,
          subsectionText: AppLocalizations.of(context)!.unknown,
          parentId: 3),
      TutorialCardModel(
          id: 23,
          pathToImage: 'assets/unknow.jpg',
          captionText: AppLocalizations.of(context)!.unknown,
          subsectionText: AppLocalizations.of(context)!.unknown,
          parentId: 4),
    ];
    List<TutorialCardModel> result = [];
    for (var tutorial in tutorials) {
      if (tutorial.parentId == id) {
        result.add(tutorial);
      }
    }
    return result;
  }

  static loadTutorial(int id, BuildContext context) {
    var tutorials = [
      TutorialModel(
          id: 6,
          pathToImage: 'assets/tutorialwhitecross.jpeg',
          subsectionText: AppLocalizations.of(context)!.firstStepText,
          parentId: 5),
      TutorialModel(
          id: 10,
          pathToImage: 'assets/whiteSide.png',
          subsectionText: AppLocalizations.of(context)!.secondStepText,
          parentId: 7),
      TutorialModel(
          id: 14,
          pathToImage: 'assets/middleLayer.png',
          subsectionText: AppLocalizations.of(context)!.thirdStepText,
          parentId: 8),
      TutorialModel(
          id: 15,
          pathToImage: 'assets/topCross.png',
          subsectionText: AppLocalizations.of(context)!.fourthStepText,
          parentId: 9),
      TutorialModel(
          id: 16,
          pathToImage: 'assets/changeEdges.png',
          subsectionText: AppLocalizations.of(context)!.fifthStepText,
          parentId: 11),
      TutorialModel(
          id: 17,
          pathToImage: 'assets/changeCorners.png',
          subsectionText: AppLocalizations.of(context)!.sixthStepText,
          parentId: 12),
      TutorialModel(
          id: 18,
          pathToImage: 'assets/turnCorners.png',
          subsectionText: AppLocalizations.of(context)!.seventhStepText,
          parentId: 13),
      TutorialModel(
          id: 20,
          pathToImage: 'assets/notation.png',
          subsectionText: AppLocalizations.of(context)!.notationText,
          parentId: 19),
      TutorialModel(
          id: 24,
          pathToImage: 'assets/unknow.jpg',
          subsectionText: AppLocalizations.of(context)!.unknownText,
          parentId: 21),
      TutorialModel(
          id: 25,
          pathToImage: 'assets/unknow.jpg',
          subsectionText: AppLocalizations.of(context)!.unknownText,
          parentId: 22),
      TutorialModel(
          id: 26,
          pathToImage: 'assets/unknow.jpg',
          subsectionText: AppLocalizations.of(context)!.unknownText,
          parentId: 23),
    ];
    for (var tutorial in tutorials) {
      if (tutorial.parentId == id) {
        return tutorial;
      }
    }
  }

  static loadCaptionText(int id, BuildContext context) {
    var tutorials = [
      TutorialCardModel(
          id: 5,
          pathToImage: 'assets/tutorialwhitecross.jpeg',
          captionText: AppLocalizations.of(context)!.whiteCross,
          subsectionText: AppLocalizations.of(context)!.firstStep,
          parentId: 1),
      TutorialCardModel(
          id: 7,
          pathToImage: 'assets/whiteSide.png',
          captionText: AppLocalizations.of(context)!.whiteSide,
          subsectionText: AppLocalizations.of(context)!.secondStep,
          parentId: 1),
      TutorialCardModel(
          id: 8,
          pathToImage: 'assets/middleLayer.png',
          captionText: AppLocalizations.of(context)!.middleLayer,
          subsectionText: AppLocalizations.of(context)!.thirdStep,
          parentId: 1),
      TutorialCardModel(
          id: 9,
          pathToImage: 'assets/topCross.png',
          captionText: AppLocalizations.of(context)!.topCross,
          subsectionText: AppLocalizations.of(context)!.fourthStep,
          parentId: 1),
      TutorialCardModel(
          id: 11,
          pathToImage: 'assets/changeEdges.png',
          captionText: AppLocalizations.of(context)!.changeEdges,
          subsectionText: AppLocalizations.of(context)!.fifthStep,
          parentId: 1),
      TutorialCardModel(
          id: 12,
          pathToImage: 'assets/changeCorners.png',
          captionText: AppLocalizations.of(context)!.changeCorners,
          subsectionText: AppLocalizations.of(context)!.sixthStep,
          parentId: 1),
      TutorialCardModel(
          id: 13,
          pathToImage: 'assets/turnCorners.png',
          captionText: AppLocalizations.of(context)!.turnCorners,
          subsectionText: AppLocalizations.of(context)!.seventhStep,
          parentId: 1),
      TutorialCardModel(
          id: 19,
          pathToImage: 'assets/notation.png',
          captionText: AppLocalizations.of(context)!.notation,
          subsectionText: AppLocalizations.of(context)!.understanding,
          parentId: 1),
      TutorialCardModel(
          id: 21,
          pathToImage: 'assets/unknow.jpg',
          captionText: AppLocalizations.of(context)!.unknown,
          subsectionText: AppLocalizations.of(context)!.unknown,
          parentId: 2),
      TutorialCardModel(
          id: 22,
          pathToImage: 'assets/unknow.jpg',
          captionText: AppLocalizations.of(context)!.unknown,
          subsectionText: AppLocalizations.of(context)!.unknown,
          parentId: 3),
      TutorialCardModel(
          id: 23,
          pathToImage: 'assets/unknow.jpg',
          captionText: AppLocalizations.of(context)!.unknown,
          subsectionText: AppLocalizations.of(context)!.unknown,
          parentId: 4),
    ];
    for (var tutorial in tutorials) {
      if (tutorial.id == id) {
        return tutorial.captionText;
      }
    }
  }
}
