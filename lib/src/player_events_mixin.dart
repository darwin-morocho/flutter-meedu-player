import 'package:flutter/services.dart';

///
/// mixin to listen the video player events
mixin MeeduPlayerEventsMixin {
  void onPlayerFinished();
  void onPlayerLoading();
  void onPlayerLoaded(Duration duration);
  void onPlayerPlaying();
  void onPlayerPaused(Duration position);
  void onPlayerPosition(Duration position);
  void onPlayerResumed();
  void onPlayerRepeat();
  void onPlayerSeekTo(Duration position);
  void onPlayerError(PlatformException e);
  void onPlayerFullScreen(bool isFullScreen);
  void onLauchAsFullScreenStopped();
}
