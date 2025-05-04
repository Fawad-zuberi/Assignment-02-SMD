import 'package:assignment2/BloC/Profile_Bloc/Profile_Event.dart';
import 'package:assignment2/BloC/Profile_Bloc/Profile_State.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileSave>(onSave);
    on<isToggle>(ontoggle);
  }

  Future<void> onSave(ProfileSave event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      final userRef =
          FirebaseFirestore.instance.collection('User').doc(event.userid);
      final updatedData = event.UpdatedValues.toJson();
      await userRef.update(updatedData);

      emit(ProfileIsSaved());

      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void ontoggle(isToggle event, Emitter<ProfileState> emit) {
    emit(ProfileIsEdit());
  }
}
