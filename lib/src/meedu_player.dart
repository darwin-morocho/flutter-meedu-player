import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'meedu_video_player_controller.dart';

class MeeduPlayer extends StatefulWidget {
  final MeeduPlayerController controller;
  const MeeduPlayer({
    Key key,
    this.controller,
  }) : super(key: key);
  @override
  _MeeduPlayerState createState() => _MeeduPlayerState();
}

class _MeeduPlayerState extends State<MeeduPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isFullScreen) return Container();
    return widget.controller.player;
  }
}
