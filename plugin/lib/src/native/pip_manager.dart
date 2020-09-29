import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class PipManager {
  final _channel = MethodChannel("app.meedu.player");
  Completer<double> _osVersion = Completer();
  Completer<bool> _pipAvailable = Completer();

  Future<double> get osVersion async {
    return _osVersion.future;
  }

  Future<bool> get pipAvailable async {
    return _pipAvailable.future;
  }

  Future<void> _getOSVersion() async {
    final os = double.parse(await _channel.invokeMethod<String>('osVersion'));
    this._osVersion.complete(os);
  }

  Future<void> enterPip() async {
    await _channel.invokeMethod('enterPip');
  }

  Future<bool> checkPipAvailable() async {
    bool available = false;
    if (Platform.isAndroid) {
      await _getOSVersion();
      final osVersion = await _osVersion.future;
      // check the OS version
      if (osVersion >= 7) {
        return true;
      }
    }
    this._pipAvailable.complete(available);
    return available;
  }
}
