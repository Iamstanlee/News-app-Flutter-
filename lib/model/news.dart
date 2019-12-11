class News {
  final dynamic articles;
  News({this.articles});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(articles: json['articles']);
  }
}
