import 'package:assignment2/Model/EventDataModel.dart';
import 'package:assignment2/Services/FireBaseEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:assignment2/Services/FirebaseAuthService.dart';
import 'package:assignment2/Model/UserDataModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mocks/firebase_mock.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthService authService;
  late FirebaseEvent firebaseEvent;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    authService = AuthService(mockFirebaseAuth, mockFirestore);

    firebaseEvent = FirebaseEvent(mockFirebaseAuth, mockFirestore);
  });

  group('AuthService', () {
    test('signUp returns UserCredential', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);
      // tells on what what we will get , mock test

      final result =
          await authService.signUp('test@example.com', 'password123');
      // checking onreal auth service if working same , real test
      expect(result, isA<UserCredential>());
    });

    test('signIn returns UserCredential', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      final result =
          await authService.signIn('test@example.com', 'password123');

      expect(result, isA<UserCredential>());
    });

    test('getUserData returns Userdatamodel if user exists', () async {
      const uid = '123';
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();

      final mockData = {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
        'profession': 'Engineer',
        'phone': '1234567890',
      };

      when(mockFirestore.collection('User')).thenReturn(mockCollection);
      when(mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn(mockData);

      final result = await authService.getUserData(uid);

      expect(result, isA<Userdatamodel>());
      expect(result!.email, 'john@example.com');
    });

    test('getUserData returns null if user does not exist', () async {
      const uid = '123';
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();

      when(mockFirestore.collection('User')).thenReturn(mockCollection);
      when(mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(false);

      final result = await authService.getUserData(uid);

      expect(result, isNull);
    });

    test('saveUserData calls Firestore set method', () async {
      const uid = '123';
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();

      final userData = {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
        'profession': 'Engineer',
        'phone': '1234567890',
      };

      when(mockFirestore.collection('User')).thenReturn(mockCollection);
      when(mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(mockDocRef.set(userData)).thenAnswer((_) async => Future.value());

      await authService.saveUserData(uid, userData);

      verify(mockDocRef.set(userData)).called(1);
    });
  });

  group('Events', () {
    test('Add an Event', () async {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();

      final event = EventModel(
        id: '',
        eventName: 'Created Event',
        venue: 'Main Hall',
        eventAuthor: 'Creator',
        date: '2025-05-20',
        timing: '7:00 PM',
        rsvp: 'Going',
        image: '',
        category: 'Art',
        authorId: '789',
      );

      when(mockFirestore.collection('events')).thenReturn(mockCollection);

      when(mockCollection.add(any)).thenAnswer((_) async =>
          MockDocumentReference()); // add any event  , called on events collection once

      await firebaseEvent.createEventInFirestore(
          event); // now on original mocket , actually called

      verify(mockCollection.add(any))
          .called(1); // verrifies that called on evnets and added
    });
  });

  test('Update an Event', () async {
    const event_id = 4;
    final event = EventModel(
      id: '$event_id',
      eventName: 'Created Event',
      venue: 'Main Hall',
      eventAuthor: 'Creator',
      date: '2025-05-20',
      timing: '7:00 PM',
      rsvp: 'Going',
      image: '',
      category: 'Art',
      authorId: '789',
    );

    final mockCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockDocRef = MockDocumentReference<Map<String, dynamic>>();

    when(mockFirestore.collection('events')).thenReturn(mockCollection);

    when(mockCollection.doc(any)).thenReturn(mockDocRef);
    when(mockDocRef.set(any)).thenAnswer((_) async => Future.value());

    await firebaseEvent.updateEventInFirestore(event);

    verify(mockCollection.doc(event.id)).called(1);

    verify(mockDocRef.set(any)).called(1);
  });
}
