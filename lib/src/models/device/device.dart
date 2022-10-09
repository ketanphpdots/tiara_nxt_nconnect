import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/device_feature.dart';
import '../../enums/device_type.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  final DeviceType type;
  final String name;
  final String mac;
  List<DeviceFeature> features;

  static SharedPreferences? _prefs;

  Device({
    required this.type,
    required this.name,
    required this.mac,
    required this.features,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);

  Future save() async {
    _prefs ??= await SharedPreferences.getInstance();
    final pairedDevices = _prefs!.getStringList('devices') ?? [];
    if (!pairedDevices.contains(mac)) {
      pairedDevices.add(mac);
      await _prefs!.setStringList('devices', pairedDevices);
    }
    await _prefs!.setString('devices.$mac', json.encode(toJson()));
  }

  static Future<List<String>> getPairedDevicesAddr() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getStringList('devices') ?? [];
  }

  static Future<Device?> load(String addr) async {
    _prefs ??= await SharedPreferences.getInstance();
    final deviceJsonString = _prefs!.getString('devices.$addr');
    if (deviceJsonString != null) {
      return Device.fromJson(json.decode(deviceJsonString));
    }
    return null;
  }

  Future delete() async {
    _prefs ??= await SharedPreferences.getInstance();
    final pairedDevices = _prefs!.getStringList('devices') ?? [];
    pairedDevices.removeWhere((element) => element == mac);
    await _prefs!.setStringList('devices', pairedDevices);
    await _prefs!.remove('devices.$mac');
  }

  Future setFeatures(List<DeviceFeature> features) async {
    this.features = features;
    save();
  }

  @override
  int get hashCode => mac.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Device && other.mac == mac;
  }
}
