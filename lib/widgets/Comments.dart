import 'package:assignment2/BloC/Auth_Bloc.dart';
import 'package:assignment2/BloC/Auth_state.dart';
import 'package:assignment2/BloC/Comment_bloc/Comment_bloc.dart';
import 'package:assignment2/BloC/Comment_bloc/Comment_event.dart';
import 'package:assignment2/BloC/Comment_bloc/Comment_state.dart';
import 'package:assignment2/Model/CommentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommentsSection extends StatefulWidget {
  final event_id;
  const CommentsSection({super.key, this.event_id});

  @override
  State<CommentsSection> createState() => commentsectionstate();
}

// ignore: camel_case_types
class commentsectionstate extends State<CommentsSection> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(FetchComment(widget.event_id));
  }

  final TextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentError) {
          Fluttertoast.showToast(msg: state.error ?? "Some Error Occured");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (state is CommentLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
            if (state is CommentsLoaded)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.comment.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final comment = state.comment[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(33, 0, 42, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(comment.commentText),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: TextController,
              decoration: InputDecoration(
                hintText: 'Leave a comment ... ',
                prefixIcon: const Icon(Icons.comment),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.text,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  final authState = context.read<AuthBloc>().state;

                  if (authState is Authenticated) {
                    final commentToAdd = CommentModel(
                      userId: authState.userid,
                      username: authState.user.firstName,
                      commentText: value.trim(),
                      timestamp: Timestamp.now(),
                    );

                    context
                        .read<CommentBloc>()
                        .add(AddComment(commentToAdd, widget.event_id));

                    TextController.clear();
                  } else {
                    Fluttertoast.showToast(
                        msg: "You must be logged in to comment.");
                  }
                }
              },
            )
          ],
        );
      },
    );
  }
}
