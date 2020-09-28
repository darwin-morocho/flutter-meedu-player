import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:meedu_player/src/controller.dart';
import 'package:meedu_player/src/helpers/responsive.dart';
import 'package:meedu_player/src/widgets/closed_caption_view.dart';
import 'package:meedu_player/src/widgets/styles/primary/primary_player_controls.dart';
import 'package:meedu_player/src/widgets/styles/secondary/secondary_player_controls.dart';
import 'package:video_player/video_player.dart';

class MeeduVideoPlayer extends StatefulWidget {
  final MeeduPlayerController controller;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  ) header;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  ) bottomRight;

  MeeduVideoPlayer(
      {Key key, @required this.controller, this.header, this.bottomRight})
      : assert(controller != null),
        super(key: key);

  @override
  _MeeduVideoPlayerState createState() => _MeeduVideoPlayerState();
}

class _MeeduVideoPlayerState extends State<MeeduVideoPlayer> {
  Widget _getView(MeeduPlayerController _) {
    if (_.dataStatus.none) return Container();
    if (_.dataStatus.loading) {
      return Center(
        child: _.placeholder,
      );
    }
    if (_.dataStatus.error) {
      return Center(
        child: Text(
          _.errorText,
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final responsive = Responsive(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        if (widget.header != null) {
          _.header = this.widget.header(context, _, responsive);
        }

        if (widget.bottomRight != null) {
          _.bottomRight = this.widget.bottomRight(context, _, responsive);
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_.videoPlayerController),
            ),
            ClosedCaptionView(responsive: responsive),
            if (_.controlsEnabled && _.controlsStyle == ControlsStyle.primary)
              PrimaryVideoPlayerControls(
                responsive: responsive,
              ),
            if (_.controlsEnabled && _.controlsStyle == ControlsStyle.secondary)
              SecondaryVideoPlayerControls(
                responsive: responsive,
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeeduPlayerController>(
      init: this.widget.controller,
      builder: (_) {
        return Container(
          color: Colors.black,
          child: Obx(
            () => _getView(_),
          ),
        );
      },
    );
  }
}
