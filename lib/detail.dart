import 'package:daily/model/DetailData.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DetailWidget extends StatelessWidget {
  final String id;

  DetailWidget(this.id);

  Future<DetailData> _requestDetail() async {
    final resp = await http.get('https://news-at.zhihu.com/api/4/news/$id');
    if (resp.statusCode == 200) {
      return DetailData.fromJson(convert.jsonDecode(resp.body));
    } else {
      throw Exception("network error");
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<DetailData>(
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
              return SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                      Image.network(detail.image),
                      Text(detail.body)
                    ]
                ),
              );
          }
        },
      );
}
