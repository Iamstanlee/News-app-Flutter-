import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as time;
import 'package:share/share.dart';
import 'dart:convert';
import 'dart:async';
import './model/news.dart';
import './components/card.dart';
import './screens/search.dart';
import './screens/web.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "News",
      debugShowCheckedModeBanner: false,
      home: new MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State createState() => MyAppState();
}

class MyAppState extends State {
  Future<News> news;
  String currentCategory = 'General';

  List<dynamic> categories = [
    {'type': 'General', 'icon': Icon(Icons.accessibility), 'action': 'general'},
    {
      'type': 'Entertainment',
      'icon': Icon(Icons.music_video),
      'action': 'entertainment'
    },
    {'type': 'Sport', 'icon': Icon(Icons.golf_course), 'action': 'sport'},
    {
      'type': 'Technology',
      'icon': Icon(Icons.laptop_chromebook),
      'action': 'technology'
    },
    {
      'type': 'Business',
      'icon': Icon(Icons.pie_chart_outlined),
      'action': 'business'
    }
  ];

  void initState() {
    super.initState();
    setState(() {
      news = getNews('General');
    });
  }

  Future<News> getNews(String category) async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=ng&category=$category&pageSize=100&apiKey=727e8a3f9249455e9ca12365a1913b20');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return News.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load news...');
    }
  }

  dynamic changeCategory(Map category) {
    setState(() {
      news = getNews(category['action']);
      currentCategory = category['type'];
    });
  }

  dynamic handleTap(String title, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Web(url, title)));
  }

  dynamic handleRating(String type) {
    //  do stuff
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Container(
              margin: EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NEWSFEED',
                    style: TextStyle(
                        fontFamily: "OperatorBold", color: Colors.red),
                  ),
                  Text(
                    currentCategory,
                    style: TextStyle(
                        color: Colors.black, fontSize: 13, fontFamily: 'Facit'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Search(currentCategory)));
                  }),
            ]),
        body: Center(
            child: FutureBuilder(
                future: news,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return ListView(
                            children: snapshot.data.articles.map<Widget>((i) {
                          return Newscard(
                              i['title'],
                              i['description'] == null
                                  ? 'No description available'
                                  : i['description'],
                              i['source']['name'],
                              i['urlToImage'],
                              time.format(DateTime.parse(i['publishedAt'])),
                              'url', () {
                            handleTap(i['title'], i['url']);
                          }, () {
                            Share.plainText(text: i['url'], title: i['title'])
                                .share();
                          });
                        }).toList());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Oops, Failed to load news...'),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: RaisedButton(
                                  elevation: 20,
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      news = getNews(currentCategory);
                                    });
                                  },
                                  child: Text(
                                    'RETRY',
                                    style: TextStyle(
                                        fontFamily: 'BRFirma',
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      throw new Exception('Something Went Wrong...');
                    default:
                      throw new Exception('Something Went Wrong...');
                  }
                })),
        floatingActionButton: UnicornDialer(
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
            parentButtonBackground: Colors.redAccent,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.add),
            childButtons: categories
                .map((i) => UnicornButton(
                      currentButton: FloatingActionButton(
                        heroTag: i['type'],
                        backgroundColor: Colors.red,
                        child: i['icon'],
                        mini: true,
                        onPressed: () {
                          changeCategory(i);
                        },
                      ),
                      labelText: i['type'],
                      hasLabel: true,
                    ))
                .toList()));
  }
}
