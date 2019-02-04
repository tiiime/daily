class DetailData {
  String body;
  String imageSource;
  String title;
  List<String> images;
  List<String> css;
  int type;
  int id;

  DetailData.fromJson(Map<String, dynamic> json) {
    body = json["body"];
    imageSource = json["imageSource"];
    title = json["title"];
    id = json["id"];
    type = json["type"];
    images = List<String>.from(json["images "] ?? []);
    css = List<String>.from(json["css "] ?? []);
  }
}
