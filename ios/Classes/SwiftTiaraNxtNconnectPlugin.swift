import Flutter
import UIKit
import nconnect4i

public class SwiftTiaraNxtNConnectPlugin: NSObject, FlutterPlugin {
    
    var stringToRfidReaderMap = [String:RfidReader]()
    
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
            result(true)
        case "getRfidReader":
            let args = call.arguments as! [String:Any]
            let make = args["make"] as! String
            let mac = args["mac"] as! String
            let success: Bool =  getRfidReader(make: make, mac: mac)
            result(success)
        case "getBatteryLevel":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let batteryLevel:Int = getBatteryLevel(mac: mac)
            result(batteryLevel)
        case "startScan":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let success: Bool = startScan(mac: mac)
            result(success)
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
    
    private func getRfidReader(make:String, mac: String) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-getRfidReader]")
        if(stringToRfidReaderMap[mac] != nil) {
            print("getRfidReader was already called for this reader in the past")
            // TODO: Disconnect the reader
        }
        do {
            let newRfidReader = try RfidFactory.getRfidReader(make: ReaderMake.WAND, hostname: mac, license: "")
            stringToRfidReaderMap[mac] = newRfidReader
            try newRfidReader.connect()
            return true
        } catch {
            print("error connecting with new reader", error)
            return false
        }
    }
    
    private func getBatteryLevel(mac: String) -> Int {
        print("[TiaraNxtNConnectPlugin.swift-getBatteryLevel]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil) {
            do {
                let b: Int? = try reader?.getBatteryLevel();
                if(b == nil) {
                    return -1
                }
                return b!
            } catch {
                print("error getting battery level of rfid reader", error)
                return -1
            }
        }
        return -1;
    }
    
    private func startScan(mac: String) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-startScan]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            do {
                try reader?.startScan()
                return true
            } catch {
                print("error starting scan of rfid reader", error)
                return false
            }
        }
        return false
    }
}

