import 'event.dart';

class ReadTagEvent extends Event {
  final String readerMac;
  final String tag;

  const ReadTagEvent({
    required this.readerMac,
    required this.tag,
  });
}
