import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:meedu_player/src/colors.dart';
import 'package:meedu_player/src/meedu_player_controls.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'meedu_fullscreen_player.dart';

enum MeeduPlayerStatus { loading, playing, paused, stopped, finished, error }

class MeeduPlayerController extends ChangeNotifier {
  VideoPlayerController _videoPlayerController;
  MeeduPlayerStatus _status = MeeduPlayerStatus.loading;
  String _dataSource;
  bool _finished = false, _isFullScreen = false;
  ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);
  ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);
  ValueNotifier<List<DurationRange>> _buffered = ValueNotifier([]);
  MeeduPlayerProvider _player;
  OverlayEntry _overlayEntry;

  MeeduPlayerStatus get status => _status;
  String get dataSource => _dataSource;
  bool get isFullScreen => _isFullScreen;
  ValueNotifier<Duration> get position => _position;
  ValueNotifier<Duration> get duration => _duration;
  ValueNotifier<List<DurationRange>> get buffered => _buffered;
  VideoPlayerController get videoPlayerController => _videoPlayerController;
  MeeduPlayerProvider get player => _player;
  MeeduPlayerController() {
    _createPlayer();
  }

  @override
  void dispose() {
    print("constroller dispose");
    fullScreenOff();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  bool get loading {
    return _status == MeeduPlayerStatus.loading;
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

  fullScreenOff() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
      _isFullScreen = false;
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
    //  await Navigator.push(context, route);
    //  _isFullScreen = false;
  }

  Future<void> setDataSource({
    @required String src,
    @required DataSourceType type,
  }) async {
    print("source $src");
    if (_dataSource == src) return;
    _dataSource = src;
    this._status = MeeduPlayerStatus.loading;
    _duration.value = Duration.zero;
    _position.value = Duration.zero;
    _finished = false;
    notifyListeners();

    if (_videoPlayerController != null) {
      await _videoPlayerController.dispose();
      _videoPlayerController = null;
    }
    if (type == DataSourceType.asset) {
      _videoPlayerController = new VideoPlayerController.asset(_dataSource);
    } else if (type == DataSourceType.network) {
      _videoPlayerController = new VideoPlayerController.network(_dataSource);
    }
    await this._initialize();
  }

  Future<void> _initialize() async {
    try {
      if (_videoPlayerController == null) return;
      await _videoPlayerController.initialize();
      await _videoPlayerController.play();
      _videoPlayerController.addListener(() {
        if (_finished) return;
        if (_status != MeeduPlayerStatus.playing &&
            _videoPlayerController.value.isPlaying) {
          _status = MeeduPlayerStatus.playing;
          notifyListeners();
        }

        final Duration duration = _videoPlayerController.value.duration;
        final Duration position = _videoPlayerController.value.position;
        if (duration != null) {
          if (duration.inSeconds != _duration.value.inSeconds) {
            _duration.value = duration;
          }
          _position.value = position;
          if (position.inSeconds == duration.inSeconds) {
            _finished = true;
            _status = MeeduPlayerStatus.finished;
            notifyListeners();
          }
        }
        _buffered.value = _videoPlayerController.value.buffered;
      });
    } on PlatformException catch (e) {
      print(e);
      this._status = MeeduPlayerStatus.error;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    if (_status != MeeduPlayerStatus.playing) return;
    if (_videoPlayerController != null) {
      await _videoPlayerController.pause();
      _status = MeeduPlayerStatus.paused;
      notifyListeners();
    }
  }

  Future<void> resume() async {
    if (_status != MeeduPlayerStatus.paused) return;
    if (_videoPlayerController != null) {
      _finished = false;
      await _videoPlayerController.play();
      _status = MeeduPlayerStatus.playing;
      notifyListeners();
    }
  }

  Future<void> repeat() async {
    if (_videoPlayerController != null) {
      _finished = false;
      await this._videoPlayerController.seekTo(Duration.zero);
      await this._videoPlayerController.play();
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

class MeeduPlayerProvider extends StatelessWidget {
  final MeeduPlayerController controller;
  MeeduPlayerProvider(this.controller);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this.controller,
      child: Hero(
        tag: 'meeduPlayer',
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: darkColor,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Consumer<MeeduPlayerController>(
                  builder: (_, controller, child) {
                    if (controller.loading) {
                      return SpinKitWave(
                        size: 30,
                        color: Colors.white,
                        duration: Duration(milliseconds: 1000),
                      );
                    } else if (controller.error) {
                      return Text(
                        "Failed to load video",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                    return VideoPlayer(
                      controller.videoPlayerController,
                    );
                  },
                ),
                MeeduPlayerControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
