import '../../tiara_nxt_nconnect.dart';

List<DeviceFeature> getDefaultDeviceFeatures(DeviceType dt) {
  switch (dt) {
    case DeviceType.sling:
      return [
        DeviceFeature.stocktake,
        DeviceFeature.singleItemSearch,
        DeviceFeature.multiItemSearch,
        DeviceFeature.smartView
      ];
    case DeviceType.slate:
      return [DeviceFeature.smartView];
    case DeviceType.surface:
      return [DeviceFeature.smartView];
    case DeviceType.paddle:
      return [
        DeviceFeature.stocktake,
        DeviceFeature.singleItemSearch,
        DeviceFeature.multiItemSearch,
        DeviceFeature.smartView
      ];
    case DeviceType.wand:
      return [
        DeviceFeature.stocktake,
        DeviceFeature.singleItemSearch,
        DeviceFeature.multiItemSearch,
        DeviceFeature.smartView
      ];
    case DeviceType.tunnel:
      return [
        DeviceFeature.stocktake,
        DeviceFeature.singleItemSearch,
        DeviceFeature.multiItemSearch
      ];
  }
}
