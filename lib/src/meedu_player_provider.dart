import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  const MeeduPlayerProvider({Key key, @required this.controller})
      : super(key: key);

  Widget _getView(MeeduPlayerController controller) {
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

    final videoAspectRatio = controller.videoPlayerController.value.aspectRatio;

    return _PlayerContainer(
      child: controller.videoPlayerController.value.initialized
          ? Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: videoAspectRatio,
                    child: VideoPlayer(
                      controller.videoPlayerController,
                    ),
                  ),
                ],
              ),
            )
          : null,
      backgroundColor: controller.backgroundColor,
      aspectRatio: controller.aspectRatio ?? videoAspectRatio,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.isFullScreen,
      builder: (BuildContext context, bool isFullScreen, Widget child) {
        return Container(
          width: double.infinity,
          height: isFullScreen ? double.infinity : null,
          child: ValueListenableBuilder(
            valueListenable: controller.status,
            builder:
                (BuildContext context, MeeduPlayerStatus value, Widget child) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _getView(controller),
                  MeeduPlayerControls(
                    controller: controller,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
