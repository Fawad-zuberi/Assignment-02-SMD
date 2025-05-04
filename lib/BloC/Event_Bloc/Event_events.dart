import 'package:assignment2/Model/EventDataModel.dart';

abstract class EventEvents {}

class FetchEventsSepcific extends EventEvents {
  final userid;
  FetchEventsSepcific(this.userid);
}

class FetchEventsAll extends EventEvents {}

class CreateEvent extends EventEvents {
  EventModel Event;

  CreateEvent(this.Event);
}

class UpdateEvent extends EventEvents {
  final EventModel Event;

  UpdateEvent(this.Event);
}

class ToggleState extends EventEvents {}
