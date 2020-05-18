import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'meedu_video_player_controller.dart';

class MeeduFullscreenPlayer extends StatefulWidget {
  final MeeduPlayerController controller;

  const MeeduFullscreenPlayer({Key key, @required this.controller})
      : super(key: key);

  @override
  _MeeduFullscreenPlayerState createState() => _MeeduFullscreenPlayerState();
}

class _MeeduFullscreenPlayerState extends State<MeeduFullscreenPlayer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.controller.backgroundColor,
      body: Center(child: widget.controller.player),
    );
  }
}
