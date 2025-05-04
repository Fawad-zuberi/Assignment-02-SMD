abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileIsEdit extends ProfileState {}

class ProfileIsSaved extends ProfileState {}

class ProfileError extends ProfileState {
  final error;

  ProfileError(this.error);
}
