import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/events/events.dart';
import 'tiara_nxt_nconnect_platform_interface.dart';

/// An implementation of [TiaraNxtNConnectPlatform] that uses event channels.
class EventChannelTiaraNxtNConnect extends TiaraNxtNConnectPlatform {
  final eventChannel = const EventChannel('tiara_nxt_nconnect/events');

  @override
  Stream<Event> getEventStream() {
    final stream = eventChannel.receiveBroadcastStream();
    stream.listen((data) {
      print('[EventChannelTiaraNxtNConnect-receiveBroadcastStream] $data');
    });
    return stream.map(
      (event) {
        final data = json.decode(event) as Map<String, dynamic>;
        if (data['event'] == 'handleData') {
          return ReadTagEvent(
            readerMac: data['readerMac'],
            tag: data['readTag'],
          );
        } else if (data['event'] == 'handleError') {
          return ErrorEvent(
            readerMac: data['readerMac'],
            error: data['error'],
          );
        } else if (data['event'] == 'handleReaderEvent') {
          return ReaderEvent(
            readerMac: data['readerMac'],
            readerEvent: data['readerEvent'],
            p1: data['p1'],
          );
        } else {
          return AnnonymousEvent(data: data);
        }
      },
    );
  }
}
