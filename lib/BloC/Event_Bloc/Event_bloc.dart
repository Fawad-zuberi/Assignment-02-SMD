import 'package:assignment2/BloC/Event_Bloc/Event_events.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_state.dart';
import 'package:assignment2/Model/EventDataModel.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventBloc extends Bloc<EventEvents, EventState> {
  EventBloc() : super(EventInitial()) {
    on<FetchEventsSepcific>(_fetchEventsforUserSpecific);
    on<FetchEventsAll>(_Fetchall);
    on<CreateEvent>(_creatorEvent);
    on<UpdateEvent>(updatorEvent);
    on<ToggleState>(_toggler);
  }

  Future<void> _fetchEventsforUserSpecific(
      FetchEventsSepcific event, Emitter<EventState> emit) async {
    emit(EventLoading());

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('uidAuthor', isEqualTo: event.userid)
          .get();

      final List<EventModel> events = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return EventModel.fromJson(data, doc.id);
      }).toList();

      print("${event.userid} has this ${events}");

      emit(EventFetchedSpecific(events));
    } catch (e) {
      emit(EventFetchError(msg: e.toString()));
    }
  }

  Future<void> _Fetchall(FetchEventsAll event, Emitter<EventState> emit) async {
    emit(EventLoading());

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('events').get();

      final List<EventModel> events = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return EventModel.fromJson(data, doc.id);
      }).toList();

      print(" we got ${events}");

      emit(EventFetched(events));
    } catch (e) {
      emit(EventFetchError(msg: e.toString()));
    }
  }

  Future<void> _creatorEvent(
      CreateEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());

    final Map<String, String> categoryImageMap = {
      'Politics': 'assets/images/politics.jpeg',
      'Art': 'assets/images/art.jpeg',
      'Music': 'assets/images/music.jpg',
      'Technology': 'assets/images/tech.jpg',
    };

    final imagePath = categoryImageMap[event.Event.category];

    final EventtoPost = {
      'eventName': event.Event.eventName,
      'venue': event.Event.venue,
      'eventAuthor': event.Event.eventAuthor,
      'date': event.Event.date,
      'timing': event.Event.timing,
      'rsvp': event.Event.rsvp,
      'image': imagePath,
      'category': event.Event.category,
      'uidAuthor': event.Event.authorId,
    };

    try {
      await FirebaseFirestore.instance.collection('events').add(EventtoPost);

      emit(EventCreated());
    } catch (e) {
      emit(EventFetchError(msg: e.toString()));
    }
  }

  Future<void> updatorEvent(UpdateEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());

    final Map<String, String> categoryImageMap = {
      'Politics': 'assets/images/politics.jpeg',
      'Education': 'assets/images/education.jpeg',
      'Entertainment': 'assets/images/music.jpg',
      'Technology': 'assets/images/tech.jpg',
      'Art': 'assets/images/art.jpeg',
    };

    final imagePath = categoryImageMap[event.Event.category];

    final EventtoPost = {
      'eventName': event.Event.eventName,
      'venue': event.Event.venue,
      'eventAuthor': event.Event.eventAuthor,
      'date': event.Event.date,
      'timing': event.Event.timing,
      'rsvp': event.Event.rsvp,
      'image': imagePath,
      'category': event.Event.category,
      'uidAuthor': event.Event.authorId,
    };

    print(event.Event.id);
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.Event.id)
          .set(EventtoPost);

      emit(EventCreated());
    } catch (e) {
      emit(EventFetchError(msg: e.toString()));
    }
  }

  void _toggler(ToggleState event, Emitter<EventState> emit) {
    emit(EventUpdatedInitial());
  }
}
