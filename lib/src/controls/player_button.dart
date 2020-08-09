import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final double size;
  final VoidCallback onPressed;
  final Color color;
  final String asset;
  const PlayerButton(
      {Key key,
      this.size = 60,
      @required this.onPressed,
      @required this.asset,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: this.onPressed,
      padding: EdgeInsets.zero,
      child: ClipOval(
        child: Container(
          width: this.size,
          height: this.size,
          padding: EdgeInsets.all(size * 0.25),
          color: this.color ?? Color(0xffd2d2d2).withOpacity(0.1),
          child: Image.asset(
            this.asset,
            color: Colors.white,
            package: 'meedu_player',
          ),
        ),
      ),
    );
  }
}
