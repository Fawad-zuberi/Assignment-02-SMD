import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userId;
  final String username;
  final String commentText;
  final Timestamp timestamp;

  CommentModel({
    required this.userId,
    required this.username,
    required this.commentText,
    required this.timestamp,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      commentText: json['commentText'] ?? '',
      timestamp: json['timestamp'] ?? Timestamp.now(),
    );
  }
}
