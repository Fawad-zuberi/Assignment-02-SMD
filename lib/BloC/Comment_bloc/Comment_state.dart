import 'package:assignment2/Model/CommentModel.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  List<CommentModel> comment;
  CommentsLoaded(this.comment);
}

class CommentError extends CommentState {
  final String? error;
  CommentError([this.error]);
}

class CommentAdded extends CommentState {}
