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
}
