import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tiara_nxt_nconnect_method_channel.dart';

abstract class TiaraNxtNConnectPlatform extends PlatformInterface {
  /// Constructs a TiaraNxtNconnectPlatform.
  TiaraNxtNConnectPlatform() : super(token: _token);

  static final Object _token = Object();

  static TiaraNxtNConnectPlatform _instance = MethodChannelTiaraNxtNConnect();

  /// The default instance of [TiaraNxtNConnectPlatform] to use.
  ///
  /// Defaults to [MethodChannelTiaraNxtNConnect].
  static TiaraNxtNConnectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TiaraNxtNConnectPlatform] when
  /// they register themselves.
  static set instance(TiaraNxtNConnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// This method is used to check plugin integration with platform
  Future<String> ping() async {
    throw UnimplementedError('ping() has not been implemented.');
  }

  ///
  Future<void> startBluetoothService() async {
    throw UnimplementedError(
      'startBluetoohService() has not been implemented.',
    );
  }

  /// This method returns a reference to an instance of RfidReader corresponding to the given hostname. If such an instance does not exist, then it creates one using the given parameters.
  ///
  /// ReaderMake is an enum used to decide what the make of the device is. The supported device makes are:
  /// 1. SLING
  /// 2. SLATE
  /// 3. WAND
  /// 4. PADDLE
  /// 5. SLEDGE
  /// 6. SURFACE
  /// 7. TUNNEL
  ///
  /// The value of platform must be one of the following:
  /// 1. windows
  /// 2. mac
  /// 3. android
  Future<bool> getRfidReader({
    required String make,
    required String addr,
  }) async {
    throw UnimplementedError(
      'getRfidReader() has not been implemented.',
    );
  }

  /// This method will return the battery level of the device if the device is a battery operated one. For non battery operated devices it will return -1.
  Future<int> getBatteryLevel() async {
    throw UnimplementedError('getBatteryLevel() has not been implemented.');
  }

  /// The startScan method is used to instruct the reader to begin scanning for RFID tags.
  Future<bool> startScan() async {
    throw UnimplementedError('startScan() has not been implemented.');
  }

  /// This method will stop the tag scanning by the reader.
  Future<bool> stopScan() async {
    throw UnimplementedError('stopScan() has not been implemented.');
  }

  /// This method will set the scanning power for the device. The scanning power affects the scan range of the device. Scan power range is 0 to 30 for all readers except TUNNEL whose range is 0 – 31.5.
  Future<void> setPower(double power) async {
    throw UnimplementedError('setPower() has not been implemented.');
  }

  /// This method returns the current power set to the device.
  Future<double> getPower() async {
    throw UnimplementedError('getPower() has not been implemented.');
  }

  /// This method will set the scanning speed for the device as a percentage of the maximum scan speed of the device. The scanning speed affects the number of tag that can be scanned by the device at a time. The scan speed can vary between 25% and 95%. The recommended value for best performance is 85%.
  Future<void> setScanSpeed(int speed) async {
    throw UnimplementedError('setScanSpeed() has not been implemented.');
  }

  /// This method will return the current scan speed set to the device.
  Future<int> getScanSpeed() async {
    throw UnimplementedError('getScanSpeed() has not been implemented.');
  }

  /// This method will write data to the tag. It will return true if the value was successfully written to the tag else it will return false.
  Future<int> writeToTag(String data) async {
    throw UnimplementedError('writeToTag() has not been implemented.');
  }

  /// The method will return the status of the reader. The following are the valid status values:
  ///   1. True: When the reader is scanning for tags.
  ///   2. False: When the reader is not scanning for tags.
  Future<bool> isScanning() async {
    throw UnimplementedError('isScanning() has not been implemented.');
  }

  /// This method will register the instance of the event listener to which will be invoked whenever a tag is scanned. Similarly there are methods to remove a single listener or to remove all listeners.
  Future<void> registerListener() async {
    throw UnimplementedError('registerListener() has not been implemented.');
  }
}
