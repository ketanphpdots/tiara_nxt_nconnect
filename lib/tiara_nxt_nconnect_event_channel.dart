import 'package:flutter/services.dart';

import 'src/models/Events.dart';
import 'src/models/annonymous_event.dart';
import 'tiara_nxt_nconnect_platform_interface.dart';

/// An implementation of [TiaraNxtNConnectPlatform] that uses event channels.
class EventChannelTiaraNxtNConnect extends TiaraNxtNConnectPlatform {
  final eventChannel = const EventChannel('tiara_nxt_nconnect/events');

  @override
  Stream<Event> getEventStream() {
    return eventChannel.receiveBroadcastStream().map(
      (event) {
        print(event);
        // TODO: map dynamic data to [Event]
        return AnnonymousEvent();
      },
    );
  }
}
