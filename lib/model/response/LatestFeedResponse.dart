import 'package:daily/model/FeedData.dart';

class LatestFeedResponse {
  String date;
  List<FeedData> stories;
  List<FeedData> topStories;

  LatestFeedResponse.fromJson(Map<String, dynamic> map) {
    date = map["date"];
    stories = List<Map<String, dynamic>>.from(map["stories"] ?? [])
        .map((it) => FeedData.fromJson(it))
        .toList();
    topStories = List<Map<String, dynamic>>.from(map["top_stories"] ?? [])
        .map((it) => FeedData.fromJson(it))
        .toList();
  }
}
