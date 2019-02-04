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
        return Text('Result: ${snapshot.data}');
    }
  }

  Future<LatestFeedResponse> fetchPost() async {
    final resp = await http.get('https://news-at.zhihu.com/api/4/news/latest');
    if (resp.statusCode == 200) {
      return LatestFeedResponse.fromJson(convert.jsonDecode(resp.body));
    } else {
      throw Exception("network error");
    }
  }
}
