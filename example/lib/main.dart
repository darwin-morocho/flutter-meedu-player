import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _MyHomePageState extends State<MyHomePage> with MeeduPlayerEventsMixin {
  final MeeduPlayerController _controller = MeeduPlayerController(
    backgroundColor: Color(0xff263238)
  );

  @override
  void initState() {
    super.initState();
    this._set(videos[0]);
    this._controller.events = this;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _set(String source) async {
    await _controller.setDataSource(
      src: source,
      type: DataSourceType.network,
      autoPlay: true,
       aspectRatio: 16/9,
      title: Text(
        source,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

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
                controller: _controller,
              ),
            )
          ];
        },
        body: ListView.builder(
          itemBuilder: (_, index) {
            return ListTile(
              onTap: () {
                this._set(videos[index]);
              },
              title: Text("View video ${index + 1}"),
            );
          },
          itemCount: videos.length,
        ),
      ),
    );
  }

  @override
  void onPlayerError(PlatformException e) {
    // TODO: implement onPlayerError
  }

  @override
  void onPlayerFinished() {
    // TODO: implement onPlayerFinished
  }

  @override
  void onPlayerFullScreen(bool isFullScreen) {
    // TODO: implement onPlayerFullScreen
  }

  @override
  void onPlayerLoaded(Duration duration) {
    // TODO: implement onPlayerLoaded
  }

  @override
  void onPlayerLoading() {
    // TODO: implement onPlayerLoading
  }

  @override
  void onPlayerPaused(Duration position) {
    // TODO: implement onPlayerPaused
  }

  @override
  void onPlayerPlaying() {
    // TODO: implement onPlayerPlaying
  }

  @override
  void onPlayerRepeat() {
    // TODO: implement onPlayerRepeat
  }

  @override
  void onPlayerResumed() {
    // TODO: implement onPlayerResumed
  }

  @override
  void onPlayerSeekTo(Duration position) {
    // TODO: implement onPlayerSeekTo
  }
}
