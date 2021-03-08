import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:meedu_player/src/helpers/responsive.dart';
import 'package:meedu_player/src/helpers/utils.dart';
import 'package:meedu_player/src/widgets/fullscreen_button.dart';
import 'package:meedu_player/src/widgets/mute_sound_button.dart';
import 'package:meedu_player/src/widgets/pip_button.dart';
import 'package:meedu_player/src/widgets/player_slider.dart';
import 'package:meedu_player/src/widgets/video_fit_button.dart';

class PrimaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryBottomControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    final fontSize = responsive.ip(2.5);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize > 17 ? 17 : fontSize,
    );
    return Positioned(
      left: 5,
      right: 0,
      bottom: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // START VIDEO POSITION
          RxBuilder(
            observables: [_.duration, _.position],
            builder: (__) => Text(
              _.duration.value.inMinutes >= 60
                  ? printDurationWithHours(_.position.value)
                  : printDuration(_.position.value),
              style: textStyle,
            ),
          ),
          // END VIDEO POSITION
          SizedBox(width: 10),
          Expanded(
            child: PlayerSlider(),
          ),
          SizedBox(width: 10),
          // START VIDEO DURATION
          RxBuilder(
            observables: [_.duration],
            builder: (__) => Text(
              _.duration.value.inMinutes >= 60
                  ? printDurationWithHours(_.duration.value)
                  : printDuration(_.duration.value),
              style: textStyle,
            ),
          ),
          // END VIDEO DURATION
          SizedBox(width: 15),
          if (_.bottomRight != null) ...[_.bottomRight!, SizedBox(width: 5)],

          if (_.enabledButtons.pip) PipButton(responsive: responsive),

          if (_.enabledButtons.videoFit) VideoFitButton(responsive: responsive),
          if (_.enabledButtons.muteAndSound)
            MuteSoundButton(responsive: responsive),

          if (_.enabledButtons.fullscreen)
            FullscreenButton(
              size: responsive.ip(_.fullscreen.value ? 5 : 7),
            )
        ],
      ),
    );
  }
}
