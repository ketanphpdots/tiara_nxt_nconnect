import 'package:json_annotation/json_annotation.dart';

enum DeviceType {
  @JsonValue('SLING')
  sling,
  @JsonValue('SLATE')
  slate,
  @JsonValue('SURFACE')
  surface,
  @JsonValue('PADDLE')
  paddle,
  @JsonValue('WAND')
  wand,
  @JsonValue('TUNNEL')
  tunnel,
}

DeviceType? stringToDeviceType(String deviceTypeString) {
  switch (deviceTypeString) {
    case 'SLING':
      return DeviceType.sling;
    case 'SLATE':
      return DeviceType.slate;
    case 'SURFACE':
      return DeviceType.surface;
    case 'PADDLE':
      return DeviceType.paddle;
    case 'WAND':
      return DeviceType.wand;
    case 'Tunnel':
      return DeviceType.tunnel;
  }
  return null;
}

String deviceTypeToString(DeviceType deviceType) {
  switch (deviceType) {
    case DeviceType.sling:
      return 'SLING';
    case DeviceType.slate:
      return 'SLATE';
    case DeviceType.surface:
      return 'SURFACE';
    case DeviceType.paddle:
      return 'PADDLE';
    case DeviceType.wand:
      return 'WAND';
    case DeviceType.tunnel:
      return 'TUNNEL';
  }
}
