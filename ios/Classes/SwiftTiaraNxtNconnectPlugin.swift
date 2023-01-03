import Flutter
import UIKit

public class SwiftTiaraNxtNConnectPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tiara_nxt_nconnect", binaryMessenger: registrar.messenger())
    let instance = SwiftTiaraNxtNConnectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
