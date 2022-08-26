import 'tiara_nxt_nconnect_platform_interface.dart';

class TiaraNxtNConnect {
  final _instance = TiaraNxtNConnectPlatform.instance;

  Future<String> ping() async {
    return _instance.ping();
  }

  Future<void> startBluetoohService() async {
    return await _instance.startBluetoothService();
  }

  Future<bool> getRfidReader({
    required String make,
    required String addr,
  }) async {
    return await _instance.getRfidReader(make: make, addr: addr);
  }

  Future<int> getBatteryLevel() async {
    return await _instance.getBatteryLevel();
  }
}
