import Flutter
import UIKit
import nconnect4i

public class SwiftTiaraNxtNConnectPlugin: NSObject, FlutterPlugin {
    
    var stringToRfidReaderMap = Dictionary<String, RfidReader>()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tiara_nxt_nconnect", binaryMessenger: registrar.messenger())
    let instance = SwiftTiaraNxtNConnectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
  }

    fileprivate func getRfidReader(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let args = call.arguments as! Dictionary<String, Any>
        var make = args["make"] as! String
        var mac = args["mac"] as! String
        do {
            if(stringToRfidReaderMap.keys.contains(mac)){
                var reader = stringToRfidReaderMap[mac]
                try reader?.disconnect()
                stringToRfidReaderMap.removeValue(forKey: mac)
            }
            var readerMake: ReaderMake
            if(mac.starts(with: "AT388")){
                readerMake = ReaderMake.WAND
            }else {
                readerMake = ReaderMake.SURFACE
            }
            var reader = try RfidFactory.getRfidReader(make: readerMake, hostname: mac, license: "")
            stringToRfidReaderMap[mac] = reader
            try reader.connect()
            result(true)
        } catch {
            print(error)
            result(false)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
    switch call.method {
        case "ping":
            result("pong")
        case "startBluetoothService":
            result(true)
        case "getRfidReader":
        getRfidReader(call, result)
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
