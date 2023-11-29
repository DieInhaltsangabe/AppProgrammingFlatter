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
          subsectionText:
              'Wir starten mit dem Lösen der weißen Kanten. Du kannst natürlich auch mit jeder anderen Farbe beginnen, doch in diesem Tutorial nehmen wir die weiße Seite als Beispiel. Wir wissen ja bereits, dass die mittleren Steine immer am gleichen Platz bleiben. Deshalb müssen wir darauf aufpassen, dass auch die zweite Farbe der Kanten mit den mittleren Steine der mittleren Seite übereinstimmt. Dieser Schritt ist intuitiv und relativ einfach, da es noch nicht so viele gelöste Steine gibt, auf die man achten muss. In vielen Fällen muss man die Kanten nur in ihren gelösten Zustand drehen. Hier sind noch ein paar Beispiele, die etwas spezieller sind.',
          parentId: 5)
    ];
    for (var tutorial in tutorials) {
      if (tutorial.parentId == id) {
        return tutorial;
      }
    }
  }

  static loadCaptionText(int id) {
    var tutorials = [
      const TutorialCardModel(
          id: 5,
          pathToImage: 'assets/tutorialwhitecross.jpeg',
          captionText: 'Weißes Kreuz',
          subsectionText: 'Erster Schritt',
          parentId: 1)
    ];
    for (var tutorial in tutorials) {
      if (tutorial.id == id) {
        return tutorial.captionText;
      }
    }
  }
}
