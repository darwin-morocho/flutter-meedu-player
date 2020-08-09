import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:meedu_player/src/colors.dart';
import 'package:video_player/video_player.dart';
import 'meedu_fullscreen_player.dart';
import 'player_events_mixin.dart';

enum MeeduPlayerStatus {
  loading,
  updating,
  loaded,
  playing,
  paused,
  stopped,
  finished,
  error
}

class MeeduPlayerController {
  /// video conatiner backgroundColor
  final Color backgroundColor;

  ///
  final List<DeviceOrientation> orientations;
  final List<SystemUiOverlay> overlays;

  final bool fullScreenAsLandscape;

  VideoPlayerController _videoPlayerController;
  ValueNotifier<MeeduPlayerStatus> _status =
      ValueNotifier(MeeduPlayerStatus.loading);

  Widget _header, _bottomLeftContent, _bottomRightContent;
  bool _finished = false, isPortrait = true, _asFullScreen = false;

  ValueNotifier<bool> _closedCaptionEnabled = ValueNotifier(true);
  ValueNotifier<bool> _isFullScreen = ValueNotifier(false);
  ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);
  ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);
  ValueNotifier<List<DurationRange>> _buffered = ValueNotifier([]);
  double _aspectRatio;

  /// mixin to listen video player events
  MeeduPlayerEventsMixin events;

  /// video player status
  ValueNotifier<MeeduPlayerStatus> get status => _status;

  /// aspect ratio for the video container
  double get aspectRatio => _aspectRatio;
  Widget get header => _header;
  Widget get bottomLeftContent => _bottomLeftContent;
  Widget get bottomRightContent => _bottomRightContent;
  ValueNotifier<bool> get isFullScreen => _isFullScreen;
  bool get asFullScreen => _asFullScreen;
  ValueNotifier<bool> get closedCaptionEnabled => _closedCaptionEnabled;

  ValueNotifier<Duration> get position => _position;

  ValueNotifier<Duration> get duration => _duration;
  ValueNotifier<List<DurationRange>> get buffered => _buffered;
  VideoPlayerController get videoPlayerController => _videoPlayerController;

  ///
  /// creates a new instance of MeeduPlayerController
  /// [backgroundColor] backgroundColor of the player
  /// [orientations] device orientation after exit of the full screen
  /// [overlays] device SystemUiOverlays after exit of the full screen
  /// [fullScreenAsLandscape] launch fullscreen as landscape or portrait
  MeeduPlayerController({
    this.backgroundColor = darkColor,
    this.orientations = DeviceOrientation.values,
    this.overlays = SystemUiOverlay.values,
    this.fullScreenAsLandscape = true,
  });

  /// release the player
  void dispose() {
    _videoPlayerController?.removeListener(this._listener);
    _videoPlayerController?.dispose();
  }

  bool get loading {
    return _status.value == MeeduPlayerStatus.loading;
  }

  bool get loaded {
    return _status.value == MeeduPlayerStatus.loaded;
  }

  bool get updating {
    return _status.value == MeeduPlayerStatus.updating;
  }

  bool get playing {
    return _status.value == MeeduPlayerStatus.playing;
  }

  bool get paused {
    return _status.value == MeeduPlayerStatus.paused;
  }

  bool get finished {
    return _status.value == MeeduPlayerStatus.finished;
  }

  bool get stopped {
    return _status.value == MeeduPlayerStatus.stopped;
  }

  bool get error {
    return _status.value == MeeduPlayerStatus.error;
  }

  /// create a new video player controller
  VideoPlayerController _createVideoController(DataSource dataSource) {
    VideoPlayerController tmp; // create a new video controller
    if (dataSource.type == DataSourceType.asset) {
      tmp = new VideoPlayerController.asset(
        dataSource.dataSource,
        closedCaptionFile: dataSource.closedCaptionFile,
        package: dataSource.package,
      );
    } else if (dataSource.type == DataSourceType.network) {
      tmp = new VideoPlayerController.network(
        dataSource.dataSource,
        formatHint: dataSource.formatHint,
        closedCaptionFile: dataSource.closedCaptionFile,
      );
    } else {
      tmp = new VideoPlayerController.file(
        dataSource.file,
        closedCaptionFile: dataSource.closedCaptionFile,
      );
    }
    return tmp;
  }

  /// use this methos to enabled str subtittles
  isClosedCaptionEnabled(bool enabled) {
    this._closedCaptionEnabled.value = enabled;
  }

  /// exit of fullscreen
  fullScreenOff(BuildContext context) {
    Navigator.pop(context);
  }

  void _checkFullScreenLandscape() {
    if (this.fullScreenAsLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  /// go to fullscreen
  Future<void> fullScreenOn(BuildContext context) async {
    final TransitionRoute<Null> route = PageRouteBuilder<Null>(
      pageBuilder: (_, __, ___) {
        return MeeduFullscreenPlayer(controller: this);
      },
    );
    Future.delayed(Duration(milliseconds: 100), () {
      _isFullScreen.value = true;
      this.events?.onPlayerFullScreen(true);
    });
    _checkFullScreenLandscape();
    await Navigator.of(context, rootNavigator: true).push(route);
    SystemChrome.setPreferredOrientations(orientations);
    SystemChrome.setEnabledSystemUIOverlays(overlays);
    _isFullScreen.value = false;
    this.events?.onPlayerFullScreen(false);
  }

  /// launchs the player as a fullscreen page
  launchAsFullScreen(
    BuildContext context, {
    @required DataSource dataSource,
    bool autoPlay = false,
    Widget header,
    Widget bottomRightContent,
    Widget bottomLeftContent,
    Duration seekTo,
  }) async {
    this._asFullScreen = true;
    this._status.value = MeeduPlayerStatus.loading;
    this._header = header;
    this._bottomLeftContent = bottomLeftContent;
    this._bottomRightContent = bottomRightContent;
    _duration.value = Duration.zero;
    _position.value = seekTo ?? Duration.zero;
    _finished = false;
    this.events?.onPlayerLoading();
    this.events?.onPlayerFullScreen(true);
    _videoPlayerController = this._createVideoController(dataSource);
    final TransitionRoute<Null> route = PageRouteBuilder<Null>(
      pageBuilder: (_, __, ___) {
        return MeeduFullscreenPlayer(controller: this);
      },
    );
    _checkFullScreenLandscape();
    Navigator.of(context, rootNavigator: true).push(route).then((value) {
      this.events?.onLauchAsFullScreenStopped();
      SystemChrome.setPreferredOrientations(orientations);
      SystemChrome.setEnabledSystemUIOverlays(overlays);
      _status.value = MeeduPlayerStatus.stopped;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _videoPlayerController?.pause();
        _videoPlayerController?.removeListener(this._listener);
        _videoPlayerController?.dispose();
        this.events?.onPlayerFullScreen(false);
      });
    });
    await this._initialize(seekTo: seekTo, autoPlay: autoPlay);
  }

  /// add the data source to the player
  /// [seekTo] start the player since the position provided
  /// [aspectRatio] aspect ratio of the player container
  Future<void> setDataSource({
    @required DataSource dataSource,
    bool autoPlay = false,
    Widget header,
    Widget bottomRightContent,
    Widget bottomLeftContent,
    double aspectRatio,
    Duration seekTo,
  }) async {
    this._aspectRatio = aspectRatio;
    this._status.value = MeeduPlayerStatus.loading;
    this._header = header;
    this._bottomLeftContent = bottomLeftContent;
    this._bottomRightContent = bottomRightContent;
    _duration.value = Duration.zero;
    _position.value = seekTo ?? Duration.zero;
    _finished = false;
    this.events?.onPlayerLoading();

    final oldController = _videoPlayerController;
    _videoPlayerController = this._createVideoController(dataSource);
    // Registering a callback for the end of next frame
    // to dispose of an old controller
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      oldController?.removeListener(this._listener);
      await oldController?.dispose();
    });
    await this._initialize(seekTo: seekTo, autoPlay: autoPlay);
  }

  /// use this method to change the video resolution, change subtitles
  Future<void> updateDataSource(
    DataSource dataSource, {
    Duration seekTo,
  }) async {
    try {
      // if the player was playing
      final bool wasPlaying = _videoPlayerController.value.isPlaying;
      // get the current video controller
      final oldController = _videoPlayerController;
      _status.value = MeeduPlayerStatus.updating; //

      // remove the previous listeners

      oldController?.removeListener(this._listener);
      _videoPlayerController = this._createVideoController(dataSource);
      _initialize(seekTo: seekTo ?? _position.value, autoPlay: wasPlaying);
      // _status.value =
      //     wasPlaying ? MeeduPlayerStatus.playing : MeeduPlayerStatus.paused;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController?.dispose(); // dispose the previous video controller
      });
    } catch (e) {
      print(e);
      this._status.value = MeeduPlayerStatus.error;
      this.events?.onPlayerError(e);
    }
  }

  // iniitialize the player
  Future<void> _initialize({
    Duration seekTo,
    bool autoPlay = false,
  }) async {
    try {
      if (_videoPlayerController == null) return;
      await _videoPlayerController.initialize();
      _status.value = MeeduPlayerStatus.loaded;
      final Duration duration = _videoPlayerController.value.duration;
      this.events?.onPlayerLoaded(duration);
      this.duration.value = duration;

      _videoPlayerController.addListener(this._listener);
      if (seekTo != null) {
        await _videoPlayerController.seekTo(seekTo);
      }
      if (autoPlay) {
        await _videoPlayerController.play();
        this.events?.onPlayerPlaying();
      }
    } on PlatformException catch (e) {
      this._status.value = MeeduPlayerStatus.error;
      this.events?.onPlayerError(e);
    }
  }

  // listener for video player events
  _listener() {
    if (_finished) return;
    if (_status.value != MeeduPlayerStatus.playing &&
        _videoPlayerController.value.isPlaying) {
      _status.value = MeeduPlayerStatus.playing;
    }
    final Duration position = _videoPlayerController.value.position;
    if (_duration != null) {
      _position.value = position;
      if (position.inSeconds == _duration.value.inSeconds) {
        _finished = true;
        _status.value = MeeduPlayerStatus.finished;
        this.events?.onPlayerFinished();
      } else {
        this.events?.onPlayerPosition(position);
      }
    }
    _buffered.value = _videoPlayerController.value.buffered;
  }

  Future<void> pause() async {
    if (_status.value != MeeduPlayerStatus.playing) return;
    if (_videoPlayerController != null) {
      await _videoPlayerController.pause();
      _status.value = MeeduPlayerStatus.paused;
      this.events?.onPlayerPaused(this.position.value);
    }
  }

  Future<void> resume() async {
    if (_status.value != MeeduPlayerStatus.paused) return;
    if (_videoPlayerController != null) {
      _finished = false;
      await _videoPlayerController.play();
      _status.value = MeeduPlayerStatus.playing;
      this.events?.onPlayerResumed();
    }
  }

  Future<void> repeat() async {
    if (_videoPlayerController != null) {
      _finished = false;
      await this._videoPlayerController.seekTo(Duration.zero);
      await this._videoPlayerController.play();
      this.events?.onPlayerRepeat();
      this._status.value = MeeduPlayerStatus.playing;
    }
  }

  Future<void> seekTo(Duration position) async {
    if (_status.value == MeeduPlayerStatus.loading) return;
    if (_videoPlayerController != null) {
      await _videoPlayerController.seekTo(position);
      _position.value = position;
      if (_finished) {
        _finished = false;
        _status.value = MeeduPlayerStatus.playing;
      }
    }
  }
}
