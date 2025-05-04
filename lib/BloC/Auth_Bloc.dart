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
    on<SignUpEvent>(onSignupEvent);
    on<Logout>(onlogoutevent);
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

      emit(Authenticated(userData!, uid));
    } on FirebaseAuthException catch (e) {
      emit(Unauthenticated(e.message));
    } catch (e) {
      emit(Unauthenticated('Login failed'));
    }
  }

  Future<void> onSignupEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Validation logic
    if (event.firstname.isEmpty ||
        event.lastname.isEmpty ||
        event.profession.isEmpty ||
        event.phone.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty) {
      emit(Unauthenticated("Please fill all fields"));
      return;
    }

    // Password length or format check
    if (event.password.length < 6) {
      emit(Unauthenticated("Password must be at least 6 characters"));
      return;
    }

    if (event.pwd != event.repwd) {
      emit(Unauthenticated("Re Entered Password Mismatch"));
      return;
    }
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: event.email, password: event.password);

      final String uid = userCredential.user!.uid;

      final userMap = {
        'firstName': event.firstname,
        'lastName': event.lastname,
        'email': event.email,
        'profession': event.profession,
        'phone': event.phone,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('User').doc(uid).set(userMap);

      final userModel = Userdatamodel.fromJson(userMap);

      emit(Authenticated(userModel, uid));
    } on FirebaseAuthException catch (e) {
      emit(Unauthenticated(e.message ?? "Signup failed"));
    } catch (e) {
      emit(Unauthenticated(e.toString()));
    }
  }

  void onlogoutevent(Logout event, Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }
}
