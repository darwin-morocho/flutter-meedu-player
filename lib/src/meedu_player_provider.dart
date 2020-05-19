import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'controls/meedu_player_controls.dart';
import 'meedu_video_player_controller.dart';

class _PlayerContainer extends StatelessWidget {
  final double aspectRatio;
  final Widget child;
  final Color backgroundColor;
  const _PlayerContainer({
    Key key,
    @required this.child,
    @required this.aspectRatio,
    @required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        color: backgroundColor,
        child: child,
      ),
    );
  }
}

class MeeduPlayerProvider extends StatelessWidget {
  final MeeduPlayerController controller;
  MeeduPlayerProvider(this.controller);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this.controller,
      child: Hero(
        tag: 'meeduPlayer',
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Consumer<MeeduPlayerController>(
              builder: (_, controller, child) {
                if (controller.loading) {
                  return _PlayerContainer(
                    child: SpinKitWave(
                      size: 30,
                      color: Colors.white,
                      duration: Duration(milliseconds: 1000),
                    ),
                    aspectRatio: controller.aspectRatio ?? 16 / 9,
                    backgroundColor: controller.backgroundColor,
                  );
                } else if (controller.error) {
                  return _PlayerContainer(
                    child: Center(
                      child: Text(
                        "Failed to load video",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    backgroundColor: controller.backgroundColor,
                    aspectRatio: controller.aspectRatio ?? 16 / 9,
                  );
                }

                final videoAspectRatio =
                    controller.videoPlayerController.value.aspectRatio;

                return _PlayerContainer(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: videoAspectRatio,
                          child: VideoPlayer(
                            controller.videoPlayerController,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 40,
                          right: 40,
                          child: ValueListenableBuilder(
                            valueListenable: controller.position,
                            builder: (_, __, child) => ClosedCaption(
                              text: controller
                                  .videoPlayerController.value.caption.text,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  backgroundColor: controller.backgroundColor,
                  aspectRatio: controller.aspectRatio ?? videoAspectRatio,
                );
              },
            ),
            MeeduPlayerControls(),
          ],
        ),
      ),
    );
  }
}
