import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:wakelock/wakelock.dart';

class BasicExamplePage extends StatefulWidget {
  BasicExamplePage({Key? key}) : super(key: key);

  @override
  _BasicExamplePageState createState() => _BasicExamplePageState();
}

class _BasicExamplePageState extends State<BasicExamplePage> {
  // read the documentation https://the-meedu-app.github.io/flutter-meedu-player/#/picture-in-picture
  // to enable the pip (picture in picture) support on Android
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
    pipEnabled: true, // enable  pip on android
    showPipButton: true, // use false to hide pip button in the player
  );

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS wakelock.
    _playerEventSubs = _meeduPlayerController.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          Wakelock.enable();
        } else {
          Wakelock.disable();
        }
      },
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    // The next line disables the wakelock again.
    _playerEventSubs?.cancel();
    Wakelock.disable();
    _meeduPlayerController.dispose();
    super.dispose();
  }

  _init() {
    _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4",
      ),
      autoplay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
