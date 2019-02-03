class FeedData {
  String title;
  List<String> images;
  bool multiPic;
  int type;
  int id;

  FeedData(this.title, this.images, this.multiPic, this.type, this.id);

  FeedData.fromJson(Map<String, dynamic> map) {
    title = map['title'];
    images = List<String>.from(map['images']);
    multiPic = map['multipic'];
    type = map['type'];
    id = map['id'];
  }
}
