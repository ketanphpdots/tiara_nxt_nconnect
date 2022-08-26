import Flutter
import UIKit

public class SwiftTiaraNxtNconnectPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tiara_nxt_nconnect", binaryMessenger: registrar.messenger())
    let instance = SwiftTiaraNxtNconnectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
