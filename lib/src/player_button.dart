import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'colors.dart';

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
          color: this.color ?? darkColor.withOpacity(0.4),
          child: SvgPicture.asset(
            this.asset,
            color: Colors.white,
            package: 'meedu_player',
          ),
        ),
      ),
    );
  }
}
