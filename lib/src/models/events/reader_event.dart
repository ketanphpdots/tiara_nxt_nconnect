import 'events.dart';

class ReaderEvent extends Event {
  final String readerMac;
  final String readerEvent;
  final String? p1;

  const ReaderEvent({
    required this.readerMac,
    required this.readerEvent,
    this.p1,
  });
}
