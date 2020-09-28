import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:meedu_player/meedu_player.dart';

import 'player_button.dart';

class PlayPauseButton extends StatelessWidget {
  final double size;
  const PlayPauseButton({Key key, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeeduPlayerController>(
      builder: (_) => Obx(
        () {
          String iconPath = 'assets/icons/repeat.png';
          if (_.playerStatus.playing) {
            iconPath = 'assets/icons/pause.png';
          } else if (_.playerStatus.paused) {
            iconPath = 'assets/icons/play.png';
          }
          return PlayerButton(
            backgrounColor: Colors.transparent,
            iconColor: Colors.white,
            onPressed: () {
              if (_.playerStatus.playing) {
                _.pause();
              } else if (_.playerStatus.paused) {
                _.play();
              } else {
                _.play(repeat: true);
              }
            },
            size: size,
            iconPath: iconPath,
          );
        },
      ),
    );
  }
}
