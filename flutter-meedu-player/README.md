# meedu_player 
<a target="blank" href="https://pub.dev/packages/meedu_player"><img src="https://img.shields.io/pub/v/meedu_player?include_prereleases&style=flat-square"/></a>

---
Modern video player UI for  [video_player](https://pub.dev/packages/video_player)


<br/>

# Getting Started

If you want to use urls with `http://` you need a little configuration.


## Android
On Android go to your `<project root>/android/app/src/main/AndroidManifest.xml`:

Add the next permission
`<uses-permission android:name="android.permission.INTERNET"/>`

And add `android:usesCleartextTraffic="true"` in your Application tag.

---
## iOS
Warning: The video player is not functional on iOS simulators. An iOS device must be used during development/testing.

Add the following entry to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```