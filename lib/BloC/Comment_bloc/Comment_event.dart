import 'package:assignment2/Model/CommentModel.dart';

abstract class CommentEvent {}

class AddComment extends CommentEvent {
  final eventid;
  CommentModel comment;
  AddComment(this.comment, this.eventid);
}

class FetchComment extends CommentEvent {
  final eventid;
  FetchComment(this.eventid);
}
