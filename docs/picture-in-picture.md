

# Picture in Picture

> Only **Android** is supported for now, pip mode on iOS is supported since iOS 14 but the flutter SDK actually does not have a stable support for iOS 14

## Android
To enable the picture in picture mode on Android you need the next requirements

In your `AndroidManifest.xml`  in your MainActivity tag you must enable `android:supportsPictureInPicture` and `android:resizeableActivity`
```xml
    <activity android:name="VideoActivity"
        android:resizeableActivity="true"
        android:supportsPictureInPicture="true"
        android:configChanges=
            "screenSize|smallestScreenSize|screenLayout|orientation"
        ...
```

> **NOTE:** The picture in picture mode is only available since **Android 7**

To enter to the picture in picture mode you can call the `enterPip` method

```dart
_meeduPlayerController.enterPip(context);
```