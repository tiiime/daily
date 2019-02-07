import 'package:daily/model/DetailData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DetailWidget extends StatefulWidget {
  final String id;
  final String cover;

  DetailWidget(this.id, this.cover);

  @override
  State<StatefulWidget> createState() => _DetailState(id, cover);
}

class _DetailState extends State<DetailWidget> {
  String id;
  String cover;
  String title = "";

  _DetailState(this.id, this.cover);

  Future<DetailData> _requestDetail() async {
    final resp = await http.get('https://news-at.zhihu.com/api/4/news/$id');
    if (resp.statusCode == 200) {
      return DetailData.fromJson(convert.jsonDecode(resp.body));
    } else {
      throw Exception("network error");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: _createBody(),
      );

  _createBody() => SingleChildScrollView(
    child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      SizedBox(
        width: double.infinity,
        child: Hero(
          tag: "feed_cover_hero_$id",
          child: Image.network(cover,fit: BoxFit.contain,),
        ),
      ),
      _requestBody()
    ]),
  );

  _requestBody() => FutureBuilder<DetailData>(
        future: _requestDetail(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');

              final detail = snapshot.data;
              print("detail ${detail.image}");
              return Text(detail.body);
          }
        },
      );
}
