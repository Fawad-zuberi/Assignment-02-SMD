import 'package:assignment2/Model/UserDataModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final userid;
  Userdatamodel user;
  Authenticated(this.user, this.userid);
}

class Unauthenticated extends AuthState {
  final String? error;
  Unauthenticated([this.error]);
}
