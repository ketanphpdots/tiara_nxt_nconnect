import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tiara_nxt_nconnect_platform_interface.dart';

/// An implementation of [TiaraNxtNConnectPlatform] that uses method channels.
class MethodChannelTiaraNxtNConnect extends TiaraNxtNConnectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tiara_nxt_nconnect');

  @override
  Future<String> ping() async {
    return await methodChannel.invokeMethod('ping') as String;
  }

  @override
  Future<void> startBluetoothService() async {
    await methodChannel.invokeMethod('startBluetoothService');
  }

  @override
  Future<bool> getRfidReader({
    required String make,
    required String addr,
  }) async {
    return await methodChannel.invokeMethod('getRfidReader', [make, addr]);
  }

  @override
  Future<int> getBatteryLevel() async {
    return await methodChannel.invokeMethod('getBatteryLevel') as int;
  }

  @override
  Future<bool> startScan() async {
    return await methodChannel.invokeMethod('startScan') as bool;
  }

  @override
  Future<bool> stopScan() async {
    return await methodChannel.invokeMethod('stopScan') as bool;
  }

  @override
  Future<void> setPower(double power) async {
    return await methodChannel.invokeMethod('setPower', power);
  }

  @override
  Future<double> getPower() async {
    return await methodChannel.invokeMethod('getPower') as double;
  }

  @override
  Future<void> setScanSpeed(int speed) async {
    return await methodChannel.invokeMethod('setScanSpeed', speed);
  }

  @override
  Future<int> getScanSpeed() async {
    return await methodChannel.invokeMethod('getScanSpeed') as int;
  }

  @override
  Future<int> writeToTag(String data) async {
    return await methodChannel.invokeMethod('writeToTag', data);
  }

  @override
  Future<bool> isScanning() async {
    return await methodChannel.invokeMethod('isScanning') as bool;
  }
}
