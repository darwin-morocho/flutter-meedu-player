# meedu_player

UI for  [video_player](https://pub.dev/packages/video_player)

| | | |
| ------------- | ------------- | ------------- |
| <img src="https://user-images.githubusercontent.com/15864336/82267395-d9846080-9931-11ea-8abf-10f8ac3fb0f3.gif" width="200" /> | <img src="https://user-images.githubusercontent.com/15864336/82736143-f384c100-9cec-11ea-83d7-1f30158fe8e7.png" width="200" />  | <img src="https://user-images.githubusercontent.com/15864336/82736145-f54e8480-9cec-11ea-9a26-6bc6267e4fdd.png" width="200" /> |









## Getting Started

If you want to use urls with http:// you need a little configuration.

### Android
On Android go to your `<project root>/android/app/src/main/AndroidManifest.xml`:

Add the next permission
`<uses-permission android:name="android.permission.INTERNET"/>`

And add `android:usesCleartextTraffic="true"` in your Application tag.

---
### iOS
Warning: The video player is not functional on iOS simulators. An iOS device must be used during development/testing.

Add the following entry to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

# Example (check the example folder to more demos)

```dart
import 'package:meedu_player/meedu_player.dart';
.
.
.

final videos = [
  'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
  'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
  'https://content.jwplatform.com/manifests/yp34SRmf.m3u8',
  'https://html5videoformatconverter.com/data/images/happyfit2.mp4'
];


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with MeeduPlayerEventsMixin {
  final MeeduPlayerController _controller = MeeduPlayerController(
    backgroundColor: Color(0xff263238)
  );

  @override
  void initState() {
    super.initState();
    this._set(videos[0]);
    this._controller.events = this; // implement the mixin to listen the player events
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _set(String source) async {
    await _controller.setDataSource(
      src: source,
      type: DataSourceType.network,
      autoPlay: true, // optional
       aspectRatio: 16/9,//optional
       title: Text(
        source,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
            // START PLAYER VIEW
          MeeduPlayer(
            controller: _controller,
          ),
            // END PLAYER VIEW
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () {
                    this._set(videos[index]);
                  },
                  title: Text("View video ${index + 1}"),
                );
              },
              itemCount: videos.length,
            ),
          )
        ],
      ),
    );
  }

  @override
  void onPlayerError(PlatformException e) {
    // TODO: implement onPlayerError
  }

  @override
  void onPlayerFinished() {
    // TODO: implement onPlayerFinished
  }

  @override
  void onPlayerFullScreen(bool isFullScreen) {
    // TODO: implement onPlayerFullScreen
  }

  @override
  void onPlayerLoaded(Duration duration) {
    // TODO: implement onPlayerLoaded
  }

  @override
  void onPlayerLoading() {
    // TODO: implement onPlayerLoading
  }

  @override
  void onPlayerPaused(Duration position) {
    // TODO: implement onPlayerPaused
  }

  @override
  void onPlayerPlaying() {
    // TODO: implement onPlayerPlaying
  }

  @override
  void onPlayerRepeat() {
    // TODO: implement onPlayerRepeat
  }

  @override
  void onPlayerResumed() {
    // TODO: implement onPlayerResumed
  }

  @override
  void onPlayerSeekTo(Duration position) {
    // TODO: implement onPlayerSeekTo
  }
}

```




