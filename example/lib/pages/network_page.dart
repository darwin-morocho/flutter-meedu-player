import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meedu_player/meedu_player.dart';

final videos = [
  'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
  'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
  'https://content.jwplatform.com/manifests/yp34SRmf.m3u8',
  'http://www.html5videoplayer.net/videos/toystory.mp4',
  'https://html5videoformatconverter.com/data/images/happyfit2.mp4',
  'http://playertest.longtailvideo.com/adaptive/bbbfull/bbbfull.m3u8',
];

class NetworkPageDemo extends StatefulWidget {
  NetworkPageDemo({Key key}) : super(key: key);

  @override
  _NetworkPageDemoState createState() => _NetworkPageDemoState();
}

class _NetworkPageDemoState extends State<NetworkPageDemo>
    with MeeduPlayerEventsMixin {
  final GlobalKey key = GlobalKey();
  final MeeduPlayerController _controller = MeeduPlayerController(
      backgroundColor: Colors.black,
      sliderColor: Colors.blue,
      orientations: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);

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
      dataSource: DataSource(
        dataSource: source,
        type: DataSourceType.network,
      ),
      autoPlay: false,
      aspectRatio: 16 / 9,
      header: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          source,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            MeeduPlayer(
              key: key,
              controller: _controller,
            ),
            Expanded(
              child: ListView.builder(
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
            )
          ],
        ),
      ),
    );
  }

  @override
  void onPlayerError(PlatformException e) {}

  @override
  void onPlayerFinished() {}

  @override
  void onPlayerFullScreen(bool isFullScreen) {}

  @override
  void onPlayerLoaded(Duration duration) {}

  @override
  void onPlayerLoading() {}

  @override
  void onPlayerPaused(Duration position) {}

  @override
  void onPlayerPlaying(Duration position) {
    print("🥶 onPlayerPlaying");
  }

  @override
  void onPlayerRepeat() {}

  @override
  void onPlayerSeekTo(Duration position) {}

  @override
  void onPlayerPosition(Duration position) {}

  @override
  void onLauchAsFullScreenStopped() {}
}
