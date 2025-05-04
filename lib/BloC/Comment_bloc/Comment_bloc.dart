import 'package:assignment2/BloC/Comment_bloc/Comment_event.dart';
import 'package:assignment2/BloC/Comment_bloc/Comment_state.dart';
import 'package:assignment2/Model/CommentModel.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentInitial()) {
    on<AddComment>(_commentadder);
    on<FetchComment>(_commentFetcher);
  }

  Future<void> _commentadder(
      AddComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final commentData = {
      'userId': event.comment.userId,
      'username': event.comment.username,
      'commentText': event.comment.commentText,
      'timestamp': FieldValue.serverTimestamp(),
    };

    print("  elo ${event.eventid} ${commentData}");

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.eventid)
          .collection('comments')
          .add(commentData);

      emit(CommentAdded());
      add(FetchComment(event.eventid));
    } on FirebaseException catch (e) {
      emit(CommentError(e.message ?? "Something Went Wrong"));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _commentFetcher(
      FetchComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());

    print("${event.eventid}");
    try {
      final QuerySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(event.eventid)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      final List<CommentModel> comment = QuerySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CommentModel.fromJson(data);
      }).toList();

      print("${comment}");
      emit(CommentsLoaded(comment));
    } on FirebaseException catch (e) {
      emit(CommentError(e.message ?? "Something Went Wrong"));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
