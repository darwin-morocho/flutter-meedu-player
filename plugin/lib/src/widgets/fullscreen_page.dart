import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx.dart';
import 'package:meedu_player/meedu_player.dart';

class MeeduPlayerFullscreenPage extends StatefulWidget {
  final MeeduPlayerController controller;
  MeeduPlayerFullscreenPage({Key key, @required this.controller})
      : super(key: key);

  @override
  _MeeduPlayerFullscreenPageState createState() =>
      _MeeduPlayerFullscreenPageState();
}

class _MeeduPlayerFullscreenPageState extends State<MeeduPlayerFullscreenPage> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: RxBuilder(
            observables: [widget.controller.videoFit],
            builder: (__) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: FittedBox(
                    fit: widget.controller.videoFit.value,
                    child: SizedBox(
                        width: _size.width,
                        height: _size.height,
                        child: MeeduVideoPlayer(
                            controller: this.widget.controller))),
              );
            }));
  }
}
