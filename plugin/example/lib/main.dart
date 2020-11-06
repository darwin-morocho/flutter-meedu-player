import 'package:flutter/material.dart';
import 'package:player_example/pages/basic_example_page.dart';
import 'package:player_example/pages/change_quality_example_page.dart';
import 'package:player_example/pages/custom_icons_example.dart';
import 'package:player_example/pages/disabled_buttons_example_page.dart';
import 'package:player_example/pages/fullscreen_example_page.dart';
import 'package:player_example/pages/network_with_subtitle_page.dart';
import 'package:player_example/pages/one_page_to_other_page_example.dart';
import 'package:player_example/pages/pick_file_page_example.dart';
import 'package:player_example/pages/playback_speed_example_page.dart';
import 'package:player_example/pages/player_with_header_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        "basic": (_) => BasicExamplePage(),
        "fullscreen": (_) => FullscreenExamplePage(),
        "with-header": (_) => PlayerWithHeaderPage(),
        "subtitles": (_) => NetworkWithSubtitlesPage(),
        "playback-speed": (_) => PlayBackSpeedExamplePage(),
        "quality-change": (_) => ChangeQualityExamplePage(),
        "one-page-to-other": (_) => OnePageExample(),
        "pick-file": (_) => PickFileExamplePage(),
        "custom-icons": (_) => CustomIconsExamplePage(),
        "disabled-buttons": (_) => DisabledButtonsExample(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'basic');
            },
            child: Text("Basic Network example"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'fullscreen');
            },
            child: Text("Fullscreen example"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'with-header');
            },
            child: Text("With header example"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'subtitles');
            },
            child: Text("With subtitles example"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'playback-speed');
            },
            child: Text("Playback speed example"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'quality-change');
            },
            child: Text("Quality Change example"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'one-page-to-other');
            },
            child: Text("One Page to other"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'pick-file');
            },
            child: Text("Pick file"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'custom-icons');
            },
            child: Text("Custom Icons"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'disabled-buttons');
            },
            child: Text("Disabled Buttons"),
          )
        ],
      ),
    );
  }
}
