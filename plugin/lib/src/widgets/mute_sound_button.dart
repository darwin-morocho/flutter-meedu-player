import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:meedu_player/src/helpers/responsive.dart';

import 'player_button.dart';

class MuteSoundButton extends StatelessWidget {
  final Responsive responsive;
  const MuteSoundButton({Key key, @required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeeduPlayerController>(
      builder: (_) => Obx(() {
        return PlayerButton(
          size: responsive.ip(_.fullscreen ? 5 : 7),
          circle: false,
          backgrounColor: Colors.transparent,
          iconColor: Colors.white,
          iconPath: _.mute ? 'assets/icons/mute.png' : 'assets/icons/sound.png',
          onPressed: () {
            _.setMute(!_.mute);
          },
        );
      }),
    );
  }
}
