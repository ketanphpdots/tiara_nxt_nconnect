import 'src/models/events/events.dart';
import 'src/tiara_nxt_nconnect_platform_interface.dart';

export 'src/enums/enums.dart';
export 'src/models/models.dart';
export 'src/helpers/default_device_features.dart';

class TiaraNxtNConnect {
  final _methodChannelInstance = TiaraNxtNConnectPlatform.methodChannelInstance;
  final _eventChannelInstance = TiaraNxtNConnectPlatform.eventChannelInstance;

  /// This method is used to check plugin integration with platform
  Future<String> ping() async {
    return _methodChannelInstance.ping();
  }

  Future<bool> setLic(String lic) async {
    return _methodChannelInstance.setLic(lic: lic);
  }

  ///
  Future<void> startBluetoothService() async {
    return await _methodChannelInstance.startBluetoothService();
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
    return await _methodChannelInstance.getRfidReader(make: make, addr: addr);
  }

  /// This method will return the battery level of the device if the device is a battery operated one. For non battery operated devices it will return -1.
  Future<int> getBatteryLevel({
    required String mac,
  }) async {
    return await _methodChannelInstance.getBatteryLevel(mac: mac);
  }

  /// The startScan method is used to instruct the reader to begin scanning for RFID tags.
  Future<bool> startScan({
    required String mac,
  }) async {
    return await _methodChannelInstance.startScan(mac: mac);
  }

  /// This method will stop the tag scanning by the reader.
  Future<bool> stopScan({
    required String mac,
  }) async {
    return await _methodChannelInstance.stopScan(mac: mac);
  }

  /// This method will set the scanning power for the device. The scanning power affects the scan range of the device. Scan power range is 0 to 30 for all readers except TUNNEL whose range is 0 – 31.5.
  Future<void> setPower({
    required String mac,
    required double power,
  }) async {
    return await _methodChannelInstance.setPower(mac: mac, power: power);
  }

  /// This method returns the current power set to the device.
  Future<double> getPower({
    required String mac,
  }) async {
    return await _methodChannelInstance.getPower(mac: mac);
  }

  /// This method will set the scanning speed for the device as a percentage of the maximum scan speed of the device. The scanning speed affects the number of tag that can be scanned by the device at a time. The scan speed can vary between 25% and 95%. The recommended value for best performance is 85%.
  Future<void> setScanSpeed({
    required String mac,
    required int speed,
  }) async {
    return await _methodChannelInstance.setScanSpeed(mac: mac, speed: speed);
  }

  /// This method will return the current scan speed set to the device.
  Future<int> getScanSpeed({
    required String mac,
  }) async {
    return await _methodChannelInstance.getScanSpeed(mac: mac);
  }

  /// This method will write data to the tag. It will return true if the value was successfully written to the tag else it will return false.
  Future<int> writeToTag({
    required String mac,
    required String data,
  }) async {
    return await _methodChannelInstance.writeToTag(mac: mac, data: data);
  }

  /// The method will return the status of the reader. The following are the valid status values:
  ///   1. True: When the reader is scanning for tags.
  ///   2. False: When the reader is not scanning for tags.
  Future<bool> isScanning({
    required String mac,
  }) async {
    return await _methodChannelInstance.isScanning(mac: mac);
  }

  Future<bool> disconnect({
    required String mac,
  }) async {
    return await _methodChannelInstance.disconnect(mac: mac);
  }

  // /// This method will register the instance of the event listener to which will be invoked whenever a tag is scanned. Similarly there are methods to remove a single listener or to remove all listeners.
  // Future<void> registerListener() async {
  //   return await _methodChannelInstance.registerListener();
  // }

  Stream<Event> getEventStrem() {
    return _eventChannelInstance.getEventStream();
  }
}
