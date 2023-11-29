class TutorialModel {
  const TutorialModel(
      {required this.id,
      required this.pathToImage,
      required this.subsectionText,
      this.parentId});
  final String pathToImage;
  final String subsectionText;
  final int id;
  final int? parentId;
}
