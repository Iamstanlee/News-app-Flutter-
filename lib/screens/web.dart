import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Web extends StatefulWidget {
  final url;
  final String title;
  Web(this.title, this.url);
  @override
  State createState() => WebState(this.url, this.title);
}

class WebState extends State<Web> {
  final url;
  bool loading = true;
  final String title;
  WebState(this.title, this.url);

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  color: Colors.black54,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                );
              },
            ),
            title: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: "OperatorBold",
                        color: Colors.red,
                        fontSize: 14),
                  ),
                  Text(
                    url,
                    style: TextStyle(
                        color: Colors.black, fontSize: 12, fontFamily: 'Facit'),
                  ),
                ],
              ),
            )),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : WebView(
                javascriptMode: JavascriptMode.unrestricted, initialUrl: url));
  }
}
