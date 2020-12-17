import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';

/// this page is only used to reproduce the github issues
class IssuesPage extends StatefulWidget {
  IssuesPage({Key key}) : super(key: key);

  @override
  _IssuesPageState createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  final MeeduPlayerController _controller_video = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
  );

  DataSource _dataSource;

  // playVideo() async {
  //   if (_dataSource == null) {
  //     _dataSource = DataSource(
  //       source: source,
  //       type: DataSourceType.network,
  //     );

  //     this._controller_video.goToFullscreen(context)

  //     await this._controller_video.launchAsFullscreen(
  //           context,
  //           dataSource: _dataSource,
  //           autoplay: true,
  //         );
  //   } else {
  //     await this._controller_video.setDataSource(
  //           _dataSource.copyWith(
  //             source: source,
  //           ),
  //           seekTo: Duration.zero,
  //         );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
          AspectRatio(
              aspectRatio: 15 / 9,
              child: MeeduVideoPlayer(
                controller: _controller_video,
                header: (ctx, controller, responsive) {
// creates a responsive fontSize using the size of video container
                  final double fontSize = responsive.ip(3);
                  return Container(
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.black12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Movie title",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize > 17 ? 17 : fontSize,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}
