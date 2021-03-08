import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx.dart';
import 'package:meedu_player/meedu_player.dart';

class MeeduPlayerFullscreenPage extends StatelessWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerFullscreenPage({Key? key, required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: RxBuilder(
        observables: [controller.videoFit],
        builder: (__) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: controller.videoFit.value,
              child: SizedBox(
                width: _size.width,
                height: _size.height,
                child: MeeduVideoPlayer(
                  controller: this.controller,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
