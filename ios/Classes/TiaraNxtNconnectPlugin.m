#import "TiaraNxtNConnectPlugin.h"
#if __has_include(<tiara_nxt_nconnect/tiara_nxt_nconnect-Swift.h>)
#import <tiara_nxt_nconnect/tiara_nxt_nconnect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tiara_nxt_nconnect-Swift.h"
#endif

@implementation TiaraNxtNConnectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTiaraNxtNConnectPlugin registerWithRegistrar:registrar];
}
@end
