import Flutter
import UIKit
import NConnectFramework

public class SwiftTiaraNxtNConnectPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    private var stringToRfidReaderMap = [String:RfidReader]()
    private var eventSink : FlutterEventSink?
    private var lic : String?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tiara_nxt_nconnect", binaryMessenger: registrar.messenger())
        let instance = SwiftTiaraNxtNConnectPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "tiara_nxt_nconnect/events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "ping":
            result("pong")
        case "setLic":
            let args = call.arguments as! [String:Any]
            let lic = args["lic"] as! String
            self.lic = lic
            result(true)
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
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let success: Bool = stopScan(mac: mac)
            result(success)
        case "setPower":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let power = args["power"] as! Double
            let success: Bool = setPower(mac: mac, power: power)
            result(success)
        case "getPower":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let p: Double = getPower(mac: mac)
            result(p)
        case "setScanSpeed":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let speed = args["speed"] as! Int
            let success: Bool = setScanSpeed(mac: mac, speed: speed)
            result(success)
        case "getScanSpeed":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let s: Double = getScanSpeed(mac: mac)
            result(s)
        case "writeToTag":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let data = args["data"] as! String
            let success: Bool = writeToTag(mac: mac, data: data)
            result(success)
        case "isScanning":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let success: Bool = isScanning(mac: mac)
            result(success)
        case "disconnect":
            let args = call.arguments as! [String:Any]
            let mac = args["mac"] as! String
            let success: Bool = disconnect(mac: mac)
            result(success)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func getRfidReader(make:String, mac: String) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-getRfidReader]")
        do {
            if(stringToRfidReaderMap[mac] != nil) {
                let reader = stringToRfidReaderMap[mac]
                let isConnected : Bool? = reader?.isConnected()
                if(isConnected != nil && isConnected!) {
                    return true
                } else {
                    let _ = disconnect(mac: mac)
                }
            }
            let readerMake: ReaderMake?
            switch make {
            case "WAND":
                readerMake = ReaderMake.WAND
            case "SURFACE":
                readerMake = ReaderMake.SURFACE
            default:
                readerMake = nil
            }
            if(readerMake == nil) {
                print(#"[TiaraNxtNConnectPlugin.swift-getRfidReader] Sorry we don't have support for make \#(make)"#)
                return false
            } else {
                let newRfidReader = try RfidFactory.getRfidReader(make: readerMake!, hostname: mac, license: lic!)
                stringToRfidReaderMap[mac] = newRfidReader
                newRfidReader.registerListener(listener: getRfidEventListener(mac: mac))
                return true
            }
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
    
    private func stopScan(mac: String) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-stopScan]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            do {
                try reader?.stopScan()
                return true
            } catch {
                print("error stopping scan of rfid reader", error)
                return false
            }
        }
        return false
    }
    
    private func setPower(mac: String, power: Double) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-setPower]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            do {
                try reader?.setPower(power: power)
                return true
            } catch {
                print("error setting power of rfid reader", error)
                return false
            }
        }
        return false
    }
    
    private func getPower(mac: String) -> Double {
        print("[TiaraNxtNConnectPlugin.swift-getPower]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            do {
                let p : Double? = try reader?.getPower()
                if (p != nil) {
                    return p!
                }
                return -1
            } catch {
                print("error getting power of rfid reader", error)
                return -1
            }
        }
        return -1
    }
    
    private func setScanSpeed(mac: String, speed: Int) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-setScanSpeed]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            do {
                try reader?.setSpeed(speed: speed)
                return true
            } catch {
                print("error getting power of rfid reader", error)
                return false
            }
        }
        return false
    }
    
    private func getScanSpeed(mac: String) -> Double {
        print("[TiaraNxtNConnectPlugin.swift-getScanSpeed]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            do {
                let p : Double? = try reader?.getSpeed()
                if (p != nil) {
                    return p!
                }
                return -1
            } catch {
                print("error getting power of rfid reader", error)
                return -1
            }
        }
        return -1
    }
    
    private func writeToTag(mac: String, data: String) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-writeToTag]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            return false
        }
        return false
    }
    
    private func isScanning(mac: String) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-isScanning]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            let p : Bool? = reader?.isScanning()
            if (p != nil) {
                return p!
            }
            return false
        }
        return false
    }
    
    private func disconnect(mac: String) -> Bool {
        print("[TiaraNxtNConnectPlugin.swift-disconnect]")
        let reader = stringToRfidReaderMap[mac]
        if(reader != nil){
            do {
                reader?.removeAllListeners()
                try reader?.disconnect()
                stringToRfidReaderMap[mac] = nil
                return true
            } catch {
                print("error disconnecting rfid reader", error)
                return false
            }
        }
        return false
    }
    
    private func getRfidEventListener(mac: String) -> RfidEventListener {
        print("[TiaraNxtNConnectPlugin.swift-getRfidEventListener]")
        
        class P : RfidEventListener {
            func handleData(tagData: String) {
                print(#"[TiaraNxtNConnectPlugin.swift-getRfidEventListener-\#(mac)-handleData]"#)
                print(#"[handleData] Read TAG: \#(tagData)"#)
                var response = [String: Any?]()
                response["event"] = "handleData"
                response["readerMac"] = mac
                response["readTag"] = DataConvertor.hexToAscii(hexString: tagData)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                    let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
                    print(jsonString)
                    eventSink?(jsonString)
                } catch {
                    print(error)
                }
            }
            
            func handleError(errorCode: NConnectFramework.ErrorCode, description: String) {
                print(#"[TiaraNxtNConnectPlugin.swift-getRfidEventListener-\#(mac)-handleError]"#)
                print(#"[handleError] ErrorCode: \#(errorCode)\tDescription: \#(description)"#)
                var response = [String: Any?]()
                response["event"] = "handleError"
                response["readerMac"] = mac
                response["error"] = errorCode
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                    let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
                    print(jsonString)
                    eventSink?(jsonString)
                } catch {
                    print(error)
                }
            }
            
            func handleEvent(eventCode: NConnectFramework.EventCode, description: String) {
                print(#"[TiaraNxtNConnectPlugin.swift-getRfidEventListener-\#(mac)-handleEvent]"#)
                print(#"[handleReaderEvent] Reader Event: \#(eventCode)\tDescription: \#(description)"#)
                var eventCodeStr : String
                switch eventCode {
                case .CONNECTED:
                    eventCodeStr = "CONNECTED"
                case .DISCONNECTED:
                    eventCodeStr = "DISCONNECTED"
                case .START_SCAN:
                    eventCodeStr = "TRIGGER_ON"
                case .STOP_SCAN:
                    eventCodeStr = "TRIGGER_OFF"
                default:
                    eventCodeStr = ""
                }
                var response = [String: Any?]()
                response["event"] = "handleReaderEvent"
                response["readerMac"] = mac
                response["readerEvent"] = eventCodeStr
                response["description"] = description
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                    let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
                    print(jsonString)
                    eventSink?(jsonString)
                } catch {
                    print(error)
                }
            }
            
            let mac : String
            let eventSink : FlutterEventSink?
            
            init(mac: String, eventSink: FlutterEventSink?) {
                self.mac = mac
                self.eventSink = eventSink
            }
        }
        return P(mac: mac, eventSink: eventSink)
    }
}

