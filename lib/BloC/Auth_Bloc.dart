import 'package:assignment2/BloC/Auth_events.dart';
import 'package:assignment2/BloC/Auth_state.dart';
import 'package:assignment2/Model/UserDataModel.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final FirebaseAuth _auth;

  AuthBloc(this._auth) : super(AuthInitial()) {
    on<LoginEvent>(onLoginEvent);
  }

  Future<void> onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final uid = userCredential.user!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('User').doc(uid).get();
      Userdatamodel? userData;

      if (userDoc.exists) {
        userData =
            Userdatamodel.fromJson(userDoc.data() as Map<String, dynamic>);
        print("User Firestore Data: ${userData.toJson()} ");
      } else {
        print("User document not found in Firestore.");
      }

      emit(Authenticated(userData!));
    } on FirebaseAuthException catch (e) {
      emit(Unauthenticated(e.message));
    } catch (e) {
      emit(Unauthenticated('Login failed'));
    }
  }
}
