import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';

class Quality {
  final String url, name;

  Quality({
    @required this.url,
    @required this.name,
  });
}

class MultiResolutionPage extends StatefulWidget {
  MultiResolutionPage({Key key}) : super(key: key);

  @override
  _MultiResolutionPageState createState() => _MultiResolutionPageState();
}

class _MultiResolutionPageState extends State<MultiResolutionPage> {
  ValueNotifier<Quality> _quality;
  DataSource _dataSource;

  final _qualities = [
    Quality(
      url:
          'https://videos-fms.jwpsrv.com/content/conversions/LOPLPiDX/videos/IFBsp7yL-24721148.mp4.m3u8?token=0_5ec8915c_0xa2f70445e1665e43dbbc78b455680d29b11304da',
      name: '720p',
    ),
    Quality(
      url:
          'https://videos-fms.jwpsrv.com/content/conversions/LOPLPiDX/videos/IFBsp7yL-24721151.mp4.m3u8?token=0_5ec8915c_0x8fcc719c73cb192592579829fe0eae0cda544d68',
      name: '1080p',
    ),
  ];

  final MeeduPlayerController _controller = MeeduPlayerController(
    backgroundColor: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    _quality = ValueNotifier(_qualities[0]);
    _dataSource = DataSource(
      dataSource: _quality.value.url,
      type: DataSourceType.network,
    );
    _set();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _set() {
    _controller.setDataSource(
      dataSource: _dataSource,
      bottomLeftContent: FlatButton(
        onPressed: this._showUpdate,
        child: ValueListenableBuilder(
          valueListenable: this._quality,
          builder: (BuildContext context, Quality quality, Widget child) {
            return Text(
              quality.name,
              style: TextStyle(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      autoPlay: true,
    );
  }

  _showUpdate() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
          actions: _qualities
              .map(
                (v) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(_);
                    if (v.url != _quality.value.url) {
                      // if the url has been changed
                      _quality.value = v;
                      _dataSource = _dataSource.copyWith(
                        dataSource: v.url,
                      );
                      _controller.updateDataSource(_dataSource);
                    }
                  },
                  child: Text(v.name),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(_);
            },
            child: Text("CANCEL"),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: MeeduPlayer(
          controller: _controller,
        ),
      ),
    );
  }
}
