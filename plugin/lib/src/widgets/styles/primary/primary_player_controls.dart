import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';

import 'package:meedu_player/src/helpers/responsive.dart';
import 'package:meedu_player/src/widgets/play_pause_button.dart';
import 'package:meedu_player/src/widgets/styles/controls_container.dart';
import 'package:meedu_player/src/widgets/styles/primary/bottom_controls.dart';
import '../../player_button.dart';

class PrimaryVideoPlayerControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryVideoPlayerControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);

    return ControlsContainer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // RENDER A CUSTOM HEADER
          if (_.header != null)
            Positioned(
              child: _.header!,
              left: 0,
              right: 0,
              top: 0,
            ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_.enabledButtons.rewindAndfastForward) ...[
                PlayerButton(
                  onPressed: _.rewind,
                  size: responsive.ip(_.fullscreen.value ? 8 : 12),
                  iconColor: Colors.white,
                  backgrounColor: Colors.transparent,
                  iconPath: 'assets/icons/rewind.png',
                  customIcon: _.customIcons.rewind,
                ),
                SizedBox(width: 10),
              ],
              if (_.enabledButtons.playPauseAndRepeat)
                PlayPauseButton(
                  size: responsive.ip(_.fullscreen.value ? 10 : 15),
                ),
              if (_.enabledButtons.rewindAndfastForward) ...[
                SizedBox(width: 10),
                PlayerButton(
                  onPressed: _.fastForward,
                  iconColor: Colors.white,
                  backgrounColor: Colors.transparent,
                  size: responsive.ip(_.fullscreen.value ? 8 : 12),
                  iconPath: 'assets/icons/fast-forward.png',
                  customIcon: _.customIcons.fastForward,
                ),
              ]
            ],
          ),

          PrimaryBottomControls(
            responsive: responsive,
          ),
        ],
      ),
    );
  }
}
