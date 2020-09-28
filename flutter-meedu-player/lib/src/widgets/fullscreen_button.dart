import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:meedu_player/meedu_player.dart';

import 'player_button.dart';

class FullscreenButton extends StatelessWidget {
  final double size;
  const FullscreenButton({Key key, this.size = 30}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeeduPlayerController>(
      builder: (_) => Obx(
        () => PlayerButton(
          size: size,
          circle: false,
          backgrounColor: Colors.transparent,
          iconColor: Colors.white,
          iconPath: _.fullscreen
              ? 'assets/icons/minimize.png'
              : 'assets/icons/fullscreen.png',
          onPressed: () {
            if (_.fullscreen) {
              // exit to fullscreen
              Navigator.pop(context);
            } else {
              _.goToFullscreen(context);
            }
          },
        ),
      ),
    );
  }
}
