import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meedu_player/meedu_player.dart';

class ListViewExample extends StatefulWidget {
  ListViewExample({Key key}) : super(key: key);

  @override
  _ListViewExampleState createState() => _ListViewExampleState();
}

class _ListViewExampleState extends State<ListViewExample> with AutomaticKeepAliveClientMixin {
  // final List<MeeduPlayerController> _controllers = [];

  // @override
  // void dispose() {
  //   _controllers.forEach((element) {
  //     element.dispose();
  //   });
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        cacheExtent: 600,
        itemBuilder: (_, index) => VideoItem(),
        itemCount: 10,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoItem extends StatefulWidget {
  VideoItem({Key key}) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with AutomaticKeepAliveClientMixin {
  MeeduPlayerController _controller = MeeduPlayerController(
    screenManager: ScreenManager(orientations: [
      DeviceOrientation.portraitUp,
    ]),
  );

  @override
  void initState() {
    super.initState();
    _controller.setDataSource(
      DataSource(
        source: 'https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4',
        type: DataSourceType.network,
      ),
      autoplay: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    print("❌ dispose video player");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: MeeduVideoPlayer(
        controller: _controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
