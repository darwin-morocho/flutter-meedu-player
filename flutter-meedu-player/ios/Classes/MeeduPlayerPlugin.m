#import "MeeduPlayerPlugin.h"
#if __has_include(<meedu_player/meedu_player-Swift.h>)
#import <meedu_player/meedu_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "meedu_player-Swift.h"
#endif

@implementation MeeduPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMeeduPlayerPlugin registerWithRegistrar:registrar];
}
@end
