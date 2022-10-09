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
    return await methodChannel.invokeMethod(
      'getRfidReader',
      {'make': make, 'mac': addr},
    );
  }

  @override
  Future<int> getBatteryLevel({
    required String mac,
  }) async {
    return await methodChannel.invokeMethod(
      'getBatteryLevel',
      {'mac': mac},
    ) as int;
  }

  @override
  Future<bool> startScan({
    required String mac,
  }) async {
    return await methodChannel.invokeMethod(
      'startScan',
      {'mac': mac},
    ) as bool;
  }

  @override
  Future<bool> stopScan({
    required String mac,
  }) async {
    return await methodChannel.invokeMethod(
      'stopScan',
      {'mac': mac},
    ) as bool;
  }

  @override
  Future<void> setPower({
    required String mac,
    required double power,
  }) async {
    return await methodChannel.invokeMethod(
      'setPower',
      {'mac': mac, 'power': power},
    );
  }

  @override
  Future<double> getPower({
    required String mac,
  }) async {
    return await methodChannel.invokeMethod(
      'getPower',
      {'mac': mac},
    ) as double;
  }

  @override
  Future<void> setScanSpeed({
    required String mac,
    required int speed,
  }) async {
    return await methodChannel.invokeMethod(
      'setScanSpeed',
      {'mac': mac, 'speed': speed},
    );
  }

  @override
  Future<int> getScanSpeed({
    required String mac,
  }) async {
    return await methodChannel.invokeMethod(
      'getScanSpeed',
      {'mac': mac},
    ) as int;
  }

  @override
  Future<int> writeToTag({
    required String mac,
    required String data,
  }) async {
    return await methodChannel.invokeMethod(
      'writeToTag',
      {'mac': mac, 'data': data},
    );
  }

  @override
  Future<bool> isScanning({
    required String mac,
  }) async {
    return await methodChannel.invokeMethod(
      'isScanning',
      {'mac': mac},
    ) as bool;
  }

  // @override
  // Future<void> registerListener() async {
  //   await methodChannel.invokeMethod('registerListener');
  // }
}
