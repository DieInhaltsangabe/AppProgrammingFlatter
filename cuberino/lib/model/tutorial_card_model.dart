// a interface technically
class TutorialCardModel {
  const TutorialCardModel(
      {required this.id,
      required this.pathToImage,
      required this.captionText,
      required this.subsectionText,
      this.parentId});
  final String pathToImage;
  final String captionText;
  final String subsectionText;
  final int id;
  final int? parentId;
}
