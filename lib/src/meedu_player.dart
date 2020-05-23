import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meedu_player/src/meedu_player_provider.dart';
import 'meedu_video_player_controller.dart';

class MeeduPlayer extends StatefulWidget {
  final MeeduPlayerController controller;
  const MeeduPlayer({
    Key key,
    @required this.controller,
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
    return ValueListenableBuilder(
      valueListenable: widget.controller.status,
      builder: (BuildContext context, MeeduPlayerStatus status, Widget child) {
        return ValueListenableBuilder(
          valueListenable: widget.controller.isFullScreen,
          builder: (BuildContext context, bool isFullScreen, Widget child) {
            if (isFullScreen) return Container();
            return Hero(
              tag: "meedu-player",
              child: Material(
                color: widget.controller.backgroundColor,
                child: MeeduPlayerProvider(controller: widget.controller),
              ),
            );
          },
        );
      },
    );
  }
}
