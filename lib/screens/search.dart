import 'package:flutter/material.dart';
import '../components/card.dart';
import './web.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as time;
import 'dart:convert';
import 'dart:async';
import '../model/news.dart';

class Search extends StatefulWidget {
  final String category;
  Search(this.category);
  @override
  State createState() => SearchState(this.category);
}

class SearchState extends State<Search> {
  SearchState(this.category);
  String category;
  String query;
  bool search = false;
  Future<News> searchResults;

  Future<News> handleSearch(String category, String term) async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=ng&category=$category&q=$term&pageSize=100&apiKey=727e8a3f9249455e9ca12365a1913b20');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return News.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load news...');
    }
  }

  TextEditingController searchControl = TextEditingController();
  dynamic handleTap(String title, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Web(url, title)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                color: Colors.black,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              );
            },
          ),
          title: TextField(
            autofocus: true,
            cursorColor: Colors.black54,
            controller: searchControl,
            style: TextStyle(color: Colors.black, fontFamily: 'Facit'),
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.black, fontFamily: 'Facit'),
                border: InputBorder.none,
                hintText: 'Search...'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  query = searchControl.text;
                  search = true;
                });
                searchResults = handleSearch(category, query);
              },
            ),
          ],
        ),
        body: Center(
            child: search
                ? FutureBuilder(
                    future: searchResults,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            if (snapshot.data.articles.length == 0) {
                              return Text(
                                'No Result Found for "$query"',
                                style: TextStyle(
                                    fontFamily: 'Facit',
                                    fontSize: 16,
                                    color: Colors.black),
                              );
                            }
                            return ListView(
                              children: snapshot.data.articles.map<Widget>((i) {
                                return Newscard(
                                    i['title'],
                                    i['description'] == null
                                        ? 'No description available'
                                        : i['description'],
                                    i['source']['name'],
                                    i['urlToImage'],
                                    time.format(
                                        DateTime.parse(i['publishedAt'])),
                                    'url', () {
                                  handleTap(i['title'], i['url']);
                                }, () {
                                  Share.plainText(
                                          text: i['url'], title: i['title'])
                                      .share();
                                });
                              }).toList(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              'Error getting results, check your internet connection and try again',
                              textAlign: TextAlign.center,
                            ));
                          }
                          throw new Exception('Something Went Wrong...');
                        default:
                          throw new Exception('Something Went Wrong...');
                      }
                    })
                : Center(
                    child: Image.asset(
                      'lib/assets/search.png',
                      height: 250,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  )));
  }
}
