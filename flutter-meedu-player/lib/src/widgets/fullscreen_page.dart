import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';

class MeeduPlayerFullscreenPage extends StatelessWidget {
  final MeeduPlayerController controller;
  const MeeduPlayerFullscreenPage({Key key, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: MeeduVideoPlayer(controller: this.controller),
      ),
    );
  }
}
