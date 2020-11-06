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
    final _ = MeeduPlayerController.of(context);
    return Obx(() {
      String iconPath = 'assets/icons/mute.png';
      Widget customIcon = _.customIcons.mute;

      if (!_.mute) {
        iconPath = 'assets/icons/sound.png';
        customIcon = _.customIcons.sound;
      }

      return PlayerButton(
        size: responsive.ip(_.fullscreen ? 5 : 7),
        circle: false,
        backgrounColor: Colors.transparent,
        iconColor: Colors.white,
        iconPath: iconPath,
        customIcon: customIcon,
        onPressed: () {
          _.setMute(!_.mute);
        },
      );
    });
  }
}
