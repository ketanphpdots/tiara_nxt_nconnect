import 'tiara_nxt_nconnect_platform_interface.dart';

class TiaraNxtNConnect {
  Future<String?> ping() {
    return TiaraNxtNConnectPlatform.instance.ping();
  }
}
