// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      type: $enumDecode(_$DeviceTypeEnumMap, json['type']),
      name: json['name'] as String,
      mac: json['addr'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => $enumDecode(_$DeviceFeatureEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'type': _$DeviceTypeEnumMap[instance.type]!,
      'name': instance.name,
      'addr': instance.mac,
      'features':
          instance.features.map((e) => _$DeviceFeatureEnumMap[e]!).toList(),
    };

const _$DeviceTypeEnumMap = {
  DeviceType.sling: 'SLING',
  DeviceType.slate: 'SLATE',
  DeviceType.surface: 'SURFACE',
  DeviceType.paddle: 'PADDLE',
  DeviceType.wand: 'WAND',
  DeviceType.tunnel: 'TUNNEL',
};

const _$DeviceFeatureEnumMap = {
  DeviceFeature.stocktake: 'stocktake',
  DeviceFeature.singleItemSearch: 'singleItemSearch',
  DeviceFeature.multiItemSearch: 'multiItemSearch',
  DeviceFeature.smartView: 'smartView',
};
