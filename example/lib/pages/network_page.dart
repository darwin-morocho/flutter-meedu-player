import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meedu_player/meedu_player.dart';

final videos = [
  'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
  'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
  'https://content.jwplatform.com/manifests/yp34SRmf.m3u8',
  'http://www.html5videoplayer.net/videos/toystory.mp4',
  'https://html5videoformatconverter.com/data/images/happyfit2.mp4',
  'http://www.html5videoplayer.net/videos/madagascar3.mp4',
];

class NetworkPageDemo extends StatefulWidget {
  NetworkPageDemo({Key key}) : super(key: key);

  @override
  _NetworkPageDemoState createState() => _NetworkPageDemoState();
}

class _NetworkPageDemoState extends State<NetworkPageDemo>
    with MeeduPlayerEventsMixin {
  final MeeduPlayerController _controller =
      MeeduPlayerController(backgroundColor: Colors.black);

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
      autoPlay: true,
      aspectRatio: 16 / 9,
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
      body: SafeArea(
              child: Column(
          children: <Widget>[
            MeeduPlayer(
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
