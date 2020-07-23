import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meedu_player/meedu_player.dart';

final videos = [
  'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
  'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
  'https://content.jwplatform.com/manifests/yp34SRmf.m3u8',
  'https://html5videoformatconverter.com/data/images/happyfit2.mp4',
];

class LaunchAsFullScreenPage extends StatefulWidget {
  LaunchAsFullScreenPage({Key key}) : super(key: key);

  @override
  _LaunchAsFullScreenPageState createState() => _LaunchAsFullScreenPageState();
}

class _LaunchAsFullScreenPageState extends State<LaunchAsFullScreenPage>
    with MeeduPlayerEventsMixin {
  final MeeduPlayerController _controller =
      MeeduPlayerController(backgroundColor: Colors.black);

  ValueNotifier<int> currentIndex = ValueNotifier(0);
  bool init = true;

  Widget get nextButton {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (_, int index, __) {
        final hasNext = index < videos.length - 1;
        return FlatButton(
          onPressed: hasNext
              ? () {
                  currentIndex.value++;
                  this._set();
                }
              : null,
          child: Text(
            "NEXT VIDEO",
            style: TextStyle(
              color: Colors.white.withOpacity(hasNext ? 1 : 0.2),
            ),
          ),
        );
      },
    );
  }

  Widget get header {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (_, int index, __) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Text(
            videos[index],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //this._set(videos[0]);
    this._controller.events = this;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _set() async {
    final index = currentIndex.value;
    if (init) {
      await this._controller.launchAsFullScreen(
            context,
            dataSource: DataSource(
              dataSource: videos[index],
              type: DataSourceType.network,
            ),
            autoPlay: true,
            header: header,
            bottomRightContent: nextButton,
          );

      init = false;
    } else {
      await this._controller.updateDataSource(
            DataSource(
              dataSource: videos[index],
              type: DataSourceType.network,
            ),
            seekTo: Duration.zero,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return ListTile(
              onTap: () {
                currentIndex.value = index;
                this._set();
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
  void onLauchAsFullScreenStopped() {
    init = true;
  }

  @override
  void onPlayerError(PlatformException e) {}

  @override
  void onPlayerFinished() {}

  @override
  void onPlayerFullScreen(bool isFullScreen) {
    print("object 🥶 $isFullScreen");
    if (isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  void onPlayerLoaded(Duration duration) {}

  @override
  void onPlayerLoading() {}

  @override
  void onPlayerPaused(Duration position) {}

  @override
  void onPlayerPlaying() {}

  @override
  void onPlayerRepeat() {}

  @override
  void onPlayerResumed() {}

  @override
  void onPlayerSeekTo(Duration position) {}

  @override
  void onPlayerPosition(Duration position) {}
}
