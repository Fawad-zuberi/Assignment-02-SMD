import 'package:assignment2/Model/UserDataModel.dart';

abstract class ProfileEvent {}

class ProfileSave extends ProfileEvent {
  Userdatamodel UpdatedValues;
  final userid;

  ProfileSave(this.UpdatedValues, this.userid);
}

class isToggle extends ProfileEvent {}
