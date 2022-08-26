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

  Future<String> ping() async {
    throw UnimplementedError('ping() has not been implemented.');
  }

  Future<void> startBluetoothService() async {
    throw UnimplementedError(
      'startBluetoohService() has not been implemented.',
    );
  }

  Future<bool> getRfidReader({
    required String make,
    required String addr,
  }) async {
    throw UnimplementedError(
      'getRfidReader() has not been implemented.',
    );
  }

  Future<int> getBatteryLevel() async {
    throw UnimplementedError('getBatteryLevel() has not been implemented.');
  }
}
