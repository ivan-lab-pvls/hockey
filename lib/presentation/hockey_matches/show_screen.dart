import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ShowLiveHockeyMatch extends StatelessWidget {
  final String show;

  const ShowLiveHockeyMatch({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          bottom: false,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(show)),
          ),
        ),
      ),
    );
  }
}
