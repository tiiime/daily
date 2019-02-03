class FeedData {
  String title;
  List<String> images;
  String image;
  bool multiPic;
  int type;
  int id;

  FeedData(this.title, this.images, this.multiPic, this.type, this.id);

  FeedData.fromJson(Map<String, dynamic> map) {
    title = map['title'];
    images = List<String>.from(map['images'] ?? []);
    image = map['image'];
    multiPic = map['multipic'];
    type = map['type'];
    id = map['id'];
  }
}
