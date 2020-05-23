import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../extras.dart';

class VideoProgressBar extends StatefulWidget {
  final Duration duration;
  final ValueNotifier<Duration> position;
  final ValueNotifier<List<DurationRange>> buffered;
  final void Function(Duration position) onSeekTo;

  VideoProgressBar({
    Key key,
    @required this.duration,
    @required this.onSeekTo,
    @required this.position,
    @required this.buffered,
  }) : super(key: key);

  @override
  _VideoProgressBarState createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  double _value = 0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _value = widget.position.value.inSeconds.toDouble();
    widget.position.addListener(this._listener);
  }

  @override
  void dispose() {
    widget.position.removeListener(this._listener);
    super.dispose();
  }

  _listener() {
    if (!_dragging) {
      _value = widget.position.value.inSeconds.toDouble();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: widget.buffered,
                builder: (BuildContext context, List<DurationRange> buffered,
                    Widget child) {
                  double loaded = 0;

                  if (buffered.length > 0) {
                    loaded = (buffered.last.end.inSeconds /
                            widget.duration.inSeconds) *
                        100;
                  }

                  return CustomPaint(
                    painter: _ProgressBarPainter(loaded),
                  );
                },
              ),
            ),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                trackShape: _CustomTrackShape(),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.0),
              ),
              child: Transform.translate(
                offset: Offset(0, 0),
                child: Container(
                  height: 25,
                  child: Slider(
                    value: _value,
                    min: 0,
                    max: widget.duration.inSeconds.toDouble(),
                    label: printDuration2(_value.toInt()),
                    divisions: 100,
                    onChanged: (v) {
                      _value = v;
                      setState(() {});
                    },
                    onChangeStart: (v) {
                      _dragging = true;
                    },
                    onChangeEnd: (v) {
                      _dragging = false;
                      widget.onSeekTo(
                        Duration(seconds: _value.toInt()),
                      );
                    },
                    activeColor: Colors.redAccent,
                    inactiveColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double loaded;

  _ProgressBarPainter(this.loaded);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 30;
    final rect = Rect.fromLTWH(0, 5 - 1.5, size.width, 3);
    canvas.drawRect(rect, paint);

    paint
      ..color = Colors.grey.withOpacity(0.9)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 30;
    final rect2 = Rect.fromLTWH(0, 5 - 1.5, size.width * loaded / 100, 3);

    canvas.drawRect(rect2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop + 5, trackWidth, trackHeight);
  }
}
