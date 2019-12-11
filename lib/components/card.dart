import "package:flutter/material.dart";
import 'dart:math' as math;

class Newscard extends StatefulWidget {
  Newscard(this.title, this.des, this.source, this.image, this.time, this.url,
      this.handleTap, this.handleShare);
  final String title;
  final String des;
  final String time;
  final String source;
  final String url;
  final String image;
  final Function handleTap;
  final Function handleShare;

  @override
  State<StatefulWidget> createState() {
    return NewsState();
  }
}

class NewsState extends State<Newscard> {
  bool liked = false;
  bool bookmark = false;
  int likes = math.Random().nextInt(200);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5.0),
        child: GestureDetector(
            onTap: widget.handleTap,
            child: Card(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text(widget.title,
                            style: TextStyle(
                                fontFamily: "BRFirma",
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.time,
                                style: TextStyle(fontFamily: "Facit")),
                            Text(widget.source,
                                style: TextStyle(
                                  fontFamily: "Facit",
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                  widget.image == null
                      ? Image.asset(
                          "lib/assets/na.jpg",
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        )
                      : FadeInImage(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          image: NetworkImage(widget.image),
                          fit: BoxFit.cover,
                          placeholder: AssetImage('lib/assets/loading.gif'),
                        ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.des + '...',
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: "Facit",
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 500,
                    child: Text(
                      '$likes Likes',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Facit',
                          color: Colors.black,
                          letterSpacing: 1.2),
                    ),
                  ),
                  Divider(height: 0.5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                            icon: liked
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(Icons.favorite_border),
                            onPressed: () {
                              setState(() {
                                liked = !liked;
                                if (liked) {
                                  setState(() {
                                    likes = likes + 1;
                                  });
                                } else {
                                  setState(() {
                                    likes = likes - 1;
                                  });
                                }
                              });
                            }),
                        IconButton(
                            icon: bookmark
                                ? Icon(
                                    Icons.bookmark,
                                    color: Colors.blue,
                                  )
                                : Icon(Icons.bookmark_border),
                            onPressed: () {
                              setState(() {
                                bookmark = !bookmark;
                                if (bookmark) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      'Bookmarked, Awesome !',
                                      style: TextStyle(
                                          fontFamily: 'Facit',
                                          fontWeight: FontWeight.w600),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                }
                              });
                            }),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: widget.handleShare,
                        )
                      ]),
                ],
              ),
            )));
  }
}
