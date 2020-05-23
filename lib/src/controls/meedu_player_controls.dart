import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:video_player/video_player.dart';
import '../meedu_video_player_controller.dart';
import 'player_button.dart';
import 'video_bottom_controls.dart';

class MeeduPlayerControls extends StatefulWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerControls({Key key, @required this.controller})
      : super(key: key);
  @override
  _MeeduPlayerControlsState createState() => _MeeduPlayerControlsState();
}

class _MeeduPlayerControlsState extends State<MeeduPlayerControls>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    if (controller.updating) {
      return Positioned.fill(
        child: Center(
          child: SpinKitWave(
            size: 30,
            color: Colors.white,
            duration: Duration(milliseconds: 1000),
          ),
        ),
      );
    }

    if (controller.loading || controller.error) return Container(height: 0);

    final visible = _visible ||
        (controller.loaded && !controller.autoPlay) ||
        controller.finished;

    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          _visible = !_visible;
          setState(() {});
        },
        child: AnimatedContainer(
          color: controller.backgroundColor.withOpacity(
            visible ? 0.6 : 0,
          ),
          height: double.infinity,
          duration: Duration(milliseconds: 300),
          child: LayoutBuilder(
            builder: (_, constraints) {
              final _Responsive responsive = _Responsive.fromSize(
                Size(constraints.maxWidth, constraints.maxHeight),
              );
              return Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  //START HEADER
                  if (controller.header != null)
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      left: 0,
                      right: 0,
                      top: _visible ? 0 : -100,
                      child: controller.header,
                    ),
                  // END HEADER

                  // START CLOSED CAPTION
                  ValueListenableBuilder(
                    valueListenable: controller.closedCaptionEnabled,
                    builder:
                        (BuildContext context, bool enabled, Widget child) {
                      if (!enabled) return Container();
                      return AnimatedPositioned(
                        left: 40,
                        right: 40,
                        bottom: visible
                            ? responsive
                                .hp(controller.isFullScreen.value ? 20 : 25)
                            : 0,
                        duration: Duration(milliseconds: 300),
                        child: ValueListenableBuilder(
                          valueListenable: controller.position,
                          builder: (_, __, child) => ClosedCaption(
                            text: controller
                                .videoPlayerController.value.caption.text,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // END CLOSED CAPTION
                  AnimatedPositioned(
                    left: 0,
                    right: 0,
                    bottom: visible ? 0 : -100,
                    duration: Duration(milliseconds: 300),
                    child: VideoBottomControls(
                      controller: controller,
                    ),
                  ),

                  AnimatedPositioned(
                    top: (visible ? 1 : -1) * constraints.maxHeight / 2 - 40,
                    duration: Duration(milliseconds: 300),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PlayerButton(
                          size: 50,
                          onPressed: () {
                            final to = controller.position.value.inSeconds - 10;
                            if (to >= 0) {
                              controller.seekTo(Duration(seconds: to));
                            }
                          },
                          asset: 'assets/icons/fast-rewind.svg',
                        ),
                        SizedBox(width: 25),
                        PlayerButton(
                          onPressed: () {
                            if (controller.playing) {
                              controller.pause();
                            } else if (controller.paused) {
                              controller.resume();
                            } else {
                              controller.repeat();
                            }
                          },
                          asset: controller.finished
                              ? 'assets/icons/repeat.svg'
                              : (controller.playing
                                  ? 'assets/icons/paused.svg'
                                  : 'assets/icons/play.svg'),
                        ),
                        SizedBox(width: 25),
                        PlayerButton(
                          size: 50,
                          onPressed: () {
                            final to = controller.position.value.inSeconds + 10;
                            if (to < controller.duration.value.inSeconds) {
                              controller.seekTo(Duration(seconds: to));
                            }
                          },
                          asset: 'assets/icons/fast-forward.svg',
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Responsive {
  double _width;
  double _height;
  double _inchScreen;

  double get width => _width;
  double get height => _height;
  double get inchScreen => _inchScreen;

  _Responsive.fromSize(Size size) {
    _width = size.width;
    _height = size.height;
    _inchScreen = math.sqrt(math.pow(width, 2) + math.pow(height, 2));
  }

  double wp(double porcentaje) {
    return width * (porcentaje / 100);
  }

  double hp(double porcentaje) {
    return height * (porcentaje / 100);
  }

  double ip(double porcentaje) {
    return inchScreen * (porcentaje / 100);
  }
}
