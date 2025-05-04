import 'package:assignment2/Model/EventDataModel.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventFetched extends EventState {
  List<EventModel> Event;

  EventFetched(this.Event);
}

class EventFetchedSpecific extends EventState {
  List<EventModel> Event;

  EventFetchedSpecific(this.Event);
}

class EventFetchError extends EventState {
  final msg;

  EventFetchError({this.msg = "Error Fetching Event"});
}

class EventCreated extends EventState {}

class EventUpdated extends EventState {}

class EventUpdatedInitial extends EventState {}
