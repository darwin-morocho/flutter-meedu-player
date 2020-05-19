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

class _MeeduPlayerState extends State<MeeduPlayer> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfIsPortrait();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _checkIfIsPortrait();
  }

  void _checkIfIsPortrait() {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.width < size.height;
    widget.controller.isPortrait = isPortrait;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isFullScreen) return Container();
    return widget.controller.player;
  }
}
