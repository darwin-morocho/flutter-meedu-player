import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:meedu_player/src/helpers/responsive.dart';

import 'player_button.dart';

class PipButton extends StatelessWidget {
  final Responsive responsive;
  const PipButton({Key key, @required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    return Obx(() {
      if (!_.pipAvailable || !_.showPipButton) return Container();
      return PlayerButton(
        size: responsive.ip(_.fullscreen ? 5 : 7),
        circle: false,
        backgrounColor: Colors.transparent,
        iconColor: Colors.white,
        iconPath: 'assets/icons/picture-in-picture.png',
        onPressed: () => _.enterPip(context),
      );
    });
  }
}
