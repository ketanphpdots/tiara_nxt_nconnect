import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/device_feature.dart';
import '../enums/device_type.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  final DeviceType type;
  final String name;
  final String addr;
  List<DeviceFeature> features;

  static SharedPreferences? _prefs;

  Device({
    required this.type,
    required this.name,
    required this.addr,
    required this.features,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);

  Future save() async {
    _prefs ??= await SharedPreferences.getInstance();
    final pairedDevices = _prefs!.getStringList('devices') ?? [];
    if (!pairedDevices.contains(addr)) {
      pairedDevices.add(addr);
      await _prefs!.setStringList('devices', pairedDevices);
    }
    await _prefs!.setString('devices.$addr', json.encode(toJson()));
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
    pairedDevices.removeWhere((element) => element == addr);
    await _prefs!.setStringList('devices', pairedDevices);
    await _prefs!.remove('devices.$addr');
  }

  Future setFeatures(List<DeviceFeature> features) async {
    this.features = features;
    save();
  }
}
