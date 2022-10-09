import 'event.dart';

class ErrorEvent extends Event {
  final String readerMac;
  final String error;

  const ErrorEvent({
    required this.readerMac,
    required this.error,
  });
}
