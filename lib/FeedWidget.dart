import 'package:daily/detail.dart';
import 'package:daily/model/FeedData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'model/response/LatestFeedResponse.dart';

class FeedWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedState();
}

class _FeedState extends State<FeedWidget> {
  Future<LatestFeedResponse> _fetchLatestFeed;

  @override
  void initState() {
    _fetchLatestFeed = fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LatestFeedResponse>(
      future: _fetchLatestFeed,
      builder: (context, snapshot) {
        return getChild(snapshot);
      });

  jump(FeedData it) => () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailWidget("${it.id}", it.image ?? it.images[0] ?? "")));
        print("tapped on ${it.id}");
      };

  getChild(snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('Press button to start.');
      case ConnectionState.active:
      case ConnectionState.waiting:
        return Text('Awaiting result...');
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return createFeedList(snapshot.data);
    }
  }

  createFeedList(LatestFeedResponse resp) => ListView.builder(
        itemCount: resp.topStories.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return AspectRatio(
              aspectRatio: 4 / 3.0,
              child: createHeaderPager(resp.topStories),
            );
          } else {
            final item = resp.stories[index - 1];
            return InkWell(
              onTap: jump(item),
              child: Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          item.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Hero(

                          tag: "feed_cover_hero_${item.id}",
                          child: Image.network(item.images[0] ?? "",
                              fit: BoxFit.cover),
                        ),
                      )
                    ],
                  )),
            );
          }
        },
      );

  createHeaderPager(List<FeedData> feeds) => PageView.builder(
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: jump(feeds[index]),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Hero(
                tag: "feed_cover_hero_${feeds[index].id}",
                child: Image.network(feeds[index].image, fit: BoxFit.fitWidth),
              ),
              Positioned(
                bottom: 0,
                child: Text(
                  feeds[index].title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        );
      });

  Future<LatestFeedResponse> fetchPost() async {
    final resp = await http.get('https://news-at.zhihu.com/api/4/news/latest');
    if (resp.statusCode == 200) {
      return LatestFeedResponse.fromJson(convert.jsonDecode(resp.body));
    } else {
      throw Exception("network error");
    }
  }
}
