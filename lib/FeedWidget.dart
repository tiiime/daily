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
  @override
  Widget build(BuildContext context) => FutureBuilder<LatestFeedResponse>(
      future: fetchPost(),
      builder: (context, snapshot) {
        return getChild(snapshot);
      });

  getChild(snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('Press button to start.');
      case ConnectionState.active:
      case ConnectionState.waiting:
        return Text('Awaiting result...');
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        for (final it in snapshot.data.stories) {
          print(it.title);
        }
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
            return ListTile(
              title: Text(item.title),
            );
          }
        },
      );

  createHeaderPager(List<FeedData> feeds) => PageView.builder(
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(feeds[index].image, fit: BoxFit.fitWidth),
            Positioned(
              bottom: 0,
              child: Text(
                feeds[index].title,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
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
