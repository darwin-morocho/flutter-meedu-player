import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:meedu_player/src/colors.dart';
import 'package:video_player/video_player.dart';
import 'meedu_fullscreen_player.dart';
import 'meedu_player_provider.dart';
import 'player_events_mixin.dart';

enum MeeduPlayerStatus {
  loading,
  loaded,
  playing,
  paused,
  stopped,
  finished,
  error
}

class DataSource {
  final File file;
  final String dataSource, package;
  final DataSourceType type;
  final VideoFormat formatHint;
  final Future<ClosedCaptionFile> closedCaptionFile;

  DataSource({
    this.file,
    this.dataSource,
    @required this.type,
    this.formatHint,
    this.package,
    this.closedCaptionFile,
  })  : assert(type != null),
        assert((type == DataSourceType.file && file != null) ||
            dataSource != null);
}

class MeeduPlayerController extends ChangeNotifier {
  final Color backgroundColor;
  VideoPlayerController _videoPlayerController;
  MeeduPlayerStatus _status = MeeduPlayerStatus.loading;
  DataSource _dataSource;

  Widget _header, _bottomLeftContent, _bottomRightContent;
  bool _finished = false,
      _isFullScreen = false,
      _autoPlay = false,
      isPortrait = true;
  ValueNotifier<bool> _closedCaptionEnabled = ValueNotifier(true);
  ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);
  ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);
  ValueNotifier<List<DurationRange>> _buffered = ValueNotifier([]);
  MeeduPlayerProvider _player;
  OverlayEntry _overlayEntry;
  double _aspectRatio;

  MeeduPlayerStatus get status => _status;
  DataSource get dataSource => _dataSource;
  double get aspectRatio => _aspectRatio;
  Widget get header => _header;
  Widget get bottomLeftContent => _bottomLeftContent;
  Widget get bottomRightContent => _bottomRightContent;
  bool get isFullScreen => _isFullScreen;
  bool get autoPlay => _autoPlay;
  ValueNotifier<bool> get closedCaptionEnabled => _closedCaptionEnabled;
  ValueNotifier<Duration> get position => _position;
  ValueNotifier<Duration> get duration => _duration;
  ValueNotifier<List<DurationRange>> get buffered => _buffered;
  VideoPlayerController get videoPlayerController => _videoPlayerController;
  MeeduPlayerProvider get player => _player;

  MeeduPlayerController({this.backgroundColor = darkColor}) {
    _createPlayer();
  }

  MeeduPlayerEventsMixin events;

  @override
  void dispose() {
    print("constroller dispose");
    fullScreenOff();
    _videoPlayerController?.removeListener(this._listener);
    _videoPlayerController?.dispose();
    super.dispose();
  }

  bool get loading {
    return _status == MeeduPlayerStatus.loading;
  }

  bool get loaded {
    return _status == MeeduPlayerStatus.loaded;
  }

  bool get playing {
    return _status == MeeduPlayerStatus.playing;
  }

  bool get paused {
    return _status == MeeduPlayerStatus.paused;
  }

  bool get finished {
    return _status == MeeduPlayerStatus.finished;
  }

  bool get error {
    return _status == MeeduPlayerStatus.error;
  }

  isClosedCaptionEnabled(bool enabled) {
    this._closedCaptionEnabled.value = enabled;
  }

  fullScreenOff() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
      _isFullScreen = false;
      this.events?.onPlayerFullScreen(false);
    }
  }

  fullScreenOn(BuildContext context) async {
    // final TransitionRoute<Null> route = PageRouteBuilder<Null>(
    //   pageBuilder: (_, __, ___) {
    //     return MeeduFullscreenPlayer(controller: this);
    //   },
    // );
    _isFullScreen = true;
    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned.fill(
          child: MeeduFullscreenPlayer(controller: this),
        );
      },
    );
    overlayState.insert(_overlayEntry);
    this.events?.onPlayerFullScreen(true);
    //  await Navigator.push(context, route);
    //  _isFullScreen = false;
  }

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
    _dataSource = dataSource;
    this._status = MeeduPlayerStatus.loading;
    this._header = header;
    this._bottomLeftContent = bottomLeftContent;
    this._bottomRightContent = bottomRightContent;
    _duration.value = Duration.zero;
    _position.value = seekTo ?? Duration.zero;
    _finished = false;
    notifyListeners();
    this.events?.onPlayerLoading();

    final oldController = _videoPlayerController;

    if (_dataSource.type == DataSourceType.asset) {
      _videoPlayerController = new VideoPlayerController.asset(
        _dataSource.dataSource,
        closedCaptionFile: _dataSource.closedCaptionFile,
        package: _dataSource.package,
      );
    } else if (_dataSource.type == DataSourceType.network) {
      _videoPlayerController = new VideoPlayerController.network(
        _dataSource.dataSource,
        formatHint: _dataSource.formatHint,
        closedCaptionFile: _dataSource.closedCaptionFile,
      );
    } else {
      _videoPlayerController = new VideoPlayerController.file(
        _dataSource.file,
        closedCaptionFile: _dataSource.closedCaptionFile,
      );
    }

    // Registering a callback for the end of next frame
    // to dispose of an old controller
    // (which won't be used anymore after calling setState)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await oldController?.dispose();
    });

    this._autoPlay = autoPlay;
    await this._initialize(seekTo: seekTo);
  }

  Future<void> _initialize({
    Duration seekTo,
  }) async {
    try {
      if (_videoPlayerController == null) return;
      await _videoPlayerController.initialize();
      _status = MeeduPlayerStatus.loaded;
      final Duration duration = _videoPlayerController.value.duration;
      this.events?.onPlayerLoaded(duration);
      this.duration.value = duration;
      notifyListeners();

      _videoPlayerController.addListener(this._listener);
      if (seekTo != null) {
        await _videoPlayerController.seekTo(seekTo);
      }
      if (this._autoPlay) {
        await _videoPlayerController.play();
        this.events?.onPlayerPlaying();
      }
    } on PlatformException catch (e) {
      this._status = MeeduPlayerStatus.error;
      this.events?.onPlayerError(e);
      notifyListeners();
    }
  }

  _listener() {
    if (_finished) return;
    if (_status != MeeduPlayerStatus.playing &&
        _videoPlayerController.value.isPlaying) {
      _status = MeeduPlayerStatus.playing;
      notifyListeners();
    }

    final Duration position = _videoPlayerController.value.position;
    if (_duration != null) {
      _position.value = position;
      if (position.inSeconds == _duration.value.inSeconds) {
        _finished = true;
        _status = MeeduPlayerStatus.finished;
        this.events?.onPlayerFinished();
        notifyListeners();
      } else {
        this.events?.onPlayerPosition(position);
      }
    }
    _buffered.value = _videoPlayerController.value.buffered;
  }

  Future<void> pause() async {
    if (_status != MeeduPlayerStatus.playing) return;
    if (_videoPlayerController != null) {
      await _videoPlayerController.pause();
      _status = MeeduPlayerStatus.paused;
      this.events?.onPlayerPaused(this.position.value);
      notifyListeners();
    }
  }

  Future<void> resume() async {
    if (_status != MeeduPlayerStatus.paused) return;
    if (_videoPlayerController != null) {
      _finished = false;
      await _videoPlayerController.play();
      _status = MeeduPlayerStatus.playing;
      this.events?.onPlayerResumed();
      notifyListeners();
    }
  }

  Future<void> repeat() async {
    if (_videoPlayerController != null) {
      _finished = false;
      await this._videoPlayerController.seekTo(Duration.zero);
      await this._videoPlayerController.play();
      this.events?.onPlayerRepeat();
      this._status = MeeduPlayerStatus.playing;
    }
  }

  Future<void> seekTo(Duration position) async {
    if (_status == MeeduPlayerStatus.loading) return;
    if (_videoPlayerController != null) {
      await _videoPlayerController.seekTo(position);
      _position.value = position;
      if (_finished) {
        _finished = false;
        _status = MeeduPlayerStatus.playing;
        notifyListeners();
      }
    }
  }

  _createPlayer() {
    this._player = MeeduPlayerProvider(this);
  }
}
