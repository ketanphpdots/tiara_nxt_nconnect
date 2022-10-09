import 'event.dart';

class AnnonymousEvent extends Event {
  final Map<String, dynamic>? data;
  const AnnonymousEvent({this.data});
}
