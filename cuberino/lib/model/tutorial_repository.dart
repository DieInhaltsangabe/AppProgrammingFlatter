import 'package:cuberino/model/tutorial_card_model.dart';
import 'package:cuberino/model/tutorial_model.dart';

class TutorialRepository {
  static loadDataParent() {
    return [
      const TutorialCardModel(
          id: 1,
          pathToImage: 'assets/starter.jpeg',
          captionText: 'Anfänger',
          subsectionText: 'Erstes mal lösen'),
      const TutorialCardModel(
          id: 2,
          pathToImage: 'assets/advanced.jpeg',
          captionText: 'Fortgeschritten',
          subsectionText: 'Tricks zum schneller lösen'),
      const TutorialCardModel(
          id: 3,
          pathToImage: 'assets/expert.jpeg',
          captionText: 'Experte',
          subsectionText: 'Einhändig Lösen'),
      const TutorialCardModel(
          id: 4,
          pathToImage: 'assets/genius.jpg',
          captionText: 'Genius',
          subsectionText: 'Lass dich überraschen'),
    ];
  }

  static loadDataChild(int id) {
    var tutorials = [
      const TutorialCardModel(
          id: 5,
          pathToImage: 'assets/tutorialwhitecross.jpeg',
          captionText: 'Weißes Kreuz',
          subsectionText: 'Erster Schritt',
          parentId: 1)
    ];
    List<TutorialCardModel> result = [];
    for (var tutorial in tutorials) {
      if (tutorial.parentId == id) {
        result.add(tutorial);
      }
    }
    return result;
  }

  static loadTutorial(int id) {
    var tutorials = [
      const TutorialModel(
          id: 6,
          pathToImage: 'assets/tutorialwhitecross.jpeg',
          subsectionText: 'Erster Schritt',
          parentId: 5)
    ];
    List<TutorialModel> result = [];
    for (var tutorial in tutorials) {
      if (tutorial.parentId == id) {
        result.add(tutorial);
      }
    }
    return result;
  }
}
