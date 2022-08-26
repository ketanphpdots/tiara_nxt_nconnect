import 'tiara_nxt_nconnect_platform_interface.dart';

class TiaraNxtNConnect {
  final _instance = TiaraNxtNConnectPlatform.instance;

  /// This method is used to check plugin integration with platform
  Future<String> ping() async {
    return _instance.ping();
  }

  ///
  Future<void> startBluetoohService() async {
    return await _instance.startBluetoothService();
  }

  /// This method returns a reference to an instance of RfidReader corresponding to the given hostname. If such an instance does not exist, then it creates one using the given parameters.
  ///
  /// ReaderMake is an enum used to decide what the make of the device is. The supported device makes are:
  ///   1. SLING
  ///   2. SLATE
  ///   3. WAND
  ///   4. PADDLE
  ///   5. SLEDGE
  ///   6. SURFACE
  ///   7. TUNNEL
  Future<bool> getRfidReader({
    required String make,
    required String addr,
  }) async {
    return await _instance.getRfidReader(make: make, addr: addr);
  }

  /// This method will return the battery level of the device if the device is a battery operated one. For non battery operated devices it will return -1.
  Future<int> getBatteryLevel() async {
    return await _instance.getBatteryLevel();
  }

  /// The startScan method is used to instruct the reader to begin scanning for RFID tags.
  Future<bool> startScan() async {
    return await _instance.startScan();
  }

  /// This method will stop the tag scanning by the reader.
  Future<bool> stopScan() async {
    return await _instance.stopScan();
  }

  /// This method will set the scanning power for the device. The scanning power affects the scan range of the device. Scan power range is 0 to 30 for all readers except TUNNEL whose range is 0 – 31.5.
  Future<void> setPower(double power) async {
    return await _instance.setPower(power);
  }

  /// This method returns the current power set to the device.
  Future<double> getPower() async {
    return await _instance.getPower();
  }

  /// This method will set the scanning speed for the device as a percentage of the maximum scan speed of the device. The scanning speed affects the number of tag that can be scanned by the device at a time. The scan speed can vary between 25% and 95%. The recommended value for best performance is 85%.
  Future<void> setScanSpeed(int speed) async {
    return await _instance.setScanSpeed(speed);
  }

  /// This method will return the current scan speed set to the device.
  Future<int> getScanSpeed() async {
    return await _instance.getScanSpeed();
  }

  /// This method will write data to the tag. It will return true if the value was successfully written to the tag else it will return false.
  Future<int> writeToTag(String data) async {
    return await _instance.writeToTag(data);
  }

  /// The method will return the status of the reader. The following are the valid status values:
  ///   1. True: When the reader is scanning for tags.
  ///   2. False: When the reader is not scanning for tags.
  Future<bool> isScanning() async {
    return await _instance.isScanning();
  }

  /// This method will register the instance of the event listener to which will be invoked whenever a tag is scanned. Similarly there are methods to remove a single listener or to remove all listeners.
  Future<void> registerListener() async {
    return await _instance.registerListener();
  }
}
