import Flutter
import UIKit

public class SwiftTiaraNxtNConnectPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tiara_nxt_nconnect", binaryMessenger: registrar.messenger())
    let instance = SwiftTiaraNxtNConnectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "ping":
            result("pong")
        case "startBluetoothService":
            result(FlutterMethodNotImplemented)
        case "getRfidReader":
            result(FlutterMethodNotImplemented)
        case "getBatteryLevel":
            result(FlutterMethodNotImplemented)
        case "startScan":
            result(FlutterMethodNotImplemented)
        case "stopScan":
            result(FlutterMethodNotImplemented)
        case "setPower":
            result(FlutterMethodNotImplemented)
        case "getPower":
            result(FlutterMethodNotImplemented)
        case "setScanSpeed":
            result(FlutterMethodNotImplemented)
        case "getScanSpeed":
            result(FlutterMethodNotImplemented)
        case "writeToTag":
            result(FlutterMethodNotImplemented)
        case "isScanning":
            result(FlutterMethodNotImplemented)
        case "disconnect":
            result(FlutterMethodNotImplemented)
        default:
            result(FlutterMethodNotImplemented)
    }
  }
}
