import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class QualityMenu extends StatefulWidget {
  QualityMenu({Key key}) : super(key: key);

  @override
  _QualityMenuState createState() => _QualityMenuState();
}

class _QualityMenuState extends State<QualityMenu> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry _overlayEntry;
  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
    }

    super.dispose();
  }

  _showQualityMenu(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }
    final OverlayState overlay = Overlay.of(context);
    final RenderBox box = _key.currentContext.findRenderObject();
    final positon = box.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: positon.dy - box.size.height - 50,
          left: positon.dx,
          child: Column(
            children: List.generate(
              3,
              (index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 1),
                  child: CupertinoButton(
                    color: darkColor.withOpacity(0.8),
                    borderRadius: BorderRadius.zero,
                    padding: EdgeInsets.all(8),
                    minSize: 25,
                    child: Text(
                      "720p",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Roboto'),
                    ),
                    onPressed: () {
                      _overlayEntry.remove();
                      _overlayEntry = null;
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: _key,
      onPressed: () {
        _showQualityMenu(context);
      },
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      child: Text(
        "720p",
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
