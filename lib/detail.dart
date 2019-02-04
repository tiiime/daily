import 'package:daily/model/DetailData.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DetailWidget extends StatelessWidget {
  final String id;

  DetailWidget(this.id);

  Future<DetailData> _requestDetail() async {
    final resp = await http.get('https://news-at.zhihu.com/api/4/news/latest');
    if (resp.statusCode == 200) {
      return DetailData.fromJson(convert.jsonDecode(resp.body));
    } else {
      throw Exception("network error");
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<DetailData>(
        future: _requestDetail(),
        builder: (context, snapshot) {},
      );
}
