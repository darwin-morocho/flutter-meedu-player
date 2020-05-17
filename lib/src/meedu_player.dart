import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'after_layout.dart';
import 'meedu_video_player_controller.dart';

class MeeduPlayer extends StatefulWidget {
  final String source;
  final VoidCallback onFinished;

  const MeeduPlayer({Key key, @required this.source, @required this.onFinished})
      : super(key: key);
  @override
  _MeeduPlayerState createState() => _MeeduPlayerState();
}

class _MeeduPlayerState extends State<MeeduPlayer> with AfterLayoutMixin {
  MeeduPlayerController _controller = MeeduPlayerController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _set(widget.source);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MeeduPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      this._set(widget.source);
    }
  }

  Future<void> _set(String source) async {
    await _controller.setDataSource(
      src: source,
      type: DataSourceType.network,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isFullScreen) return Container();
    return _controller.player;
  }
}
