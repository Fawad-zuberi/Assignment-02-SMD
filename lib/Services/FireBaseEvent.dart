import 'package:assignment2/Model/EventDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEvent {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseEvent(this._auth, this._firestore);

  Future<List<EventModel>> fetchEventsForUser(String userId) async {
    final querySnapshot = await _firestore
        .collection('events')
        .where('uidAuthor', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return EventModel.fromJson(data, doc.id);
    }).toList();
  }

  // Fetch all events
  Future<List<EventModel>> fetchAllEvents() async {
    final querySnapshot = await _firestore.collection('events').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return EventModel.fromJson(data, doc.id);
    }).toList();
  }

  // Create an event in Firestore
  Future<void> createEventInFirestore(EventModel event) async {
    final Map<String, String> categoryImageMap = {
      'Politics': 'assets/images/politics.jpeg',
      'Art': 'assets/images/art.jpeg',
      'Music': 'assets/images/music.jpg',
      'Technology': 'assets/images/tech.jpg',
    };

    final imagePath = categoryImageMap[event.category];

    final eventToPost = {
      'eventName': event.eventName,
      'venue': event.venue,
      'eventAuthor': event.eventAuthor,
      'date': event.date,
      'timing': event.timing,
      'rsvp': event.rsvp,
      'image': imagePath,
      'category': event.category,
      'uidAuthor': event.authorId,
    };

    await _firestore.collection('events').add(eventToPost);
  }

  // Update an event in Firestore
  Future<void> updateEventInFirestore(EventModel event) async {
    final Map<String, String> categoryImageMap = {
      'Politics': 'assets/images/politics.jpeg',
      'Education': 'assets/images/education.jpeg',
      'Entertainment': 'assets/images/music.jpg',
      'Technology': 'assets/images/tech.jpg',
      'Art': 'assets/images/art.jpeg',
    };

    final imagePath = categoryImageMap[event.category];

    final eventToPost = {
      'eventName': event.eventName,
      'venue': event.venue,
      'eventAuthor': event.eventAuthor,
      'date': event.date,
      'timing': event.timing,
      'rsvp': event.rsvp,
      'image': imagePath,
      'category': event.category,
      'uidAuthor': event.authorId,
    };

    await _firestore.collection('events').doc(event.id).set(eventToPost);
  }
}
