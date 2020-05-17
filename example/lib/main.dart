import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final videos = [
  'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
  'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
  'https://content.jwplatform.com/manifests/yp34SRmf.m3u8',
  'http://www.html5videoplayer.net/videos/toystory.mp4',
  'https://html5videoformatconverter.com/data/images/happyfit2.mp4',
  'http://www.html5videoplayer.net/videos/madagascar3.mp4',
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _dataSource = videos[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverToBoxAdapter(
              child: MeeduPlayer(
                source: _dataSource,
                onFinished: () {},
              ),
            )
          ];
        },
        body: ListView.builder(
          itemBuilder: (_, index) {
            return ListTile(
              onTap: () {
                setState(() {
                  _dataSource = videos[index];
                });
              },
              title: Text("View video ${index + 1}"),
            );
          },
          itemCount: videos.length,
        ),
      ),
    );
  }
}
