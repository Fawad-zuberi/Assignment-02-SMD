import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key});

  @override
  State<CommentsSection> createState() => commentsectionstate();
}

// ignore: camel_case_types
class commentsectionstate extends State<CommentsSection> {
  final List<Map<String, String>> comments = [
    {'user': 'Alice', 'text': 'Great event! Had a lot of fun.'},
    {'user': 'Bob', 'text': 'Looking forward to the next one.'},
    {'user': 'Charlie', 'text': 'Everything was well organized.'},
  ];

  final TextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        const Text(
          'Comments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final comment = comments[index];
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
                          comment['user']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(comment['text']!),
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
              setState(() {
                comments.add({'user': 'CurrentUser', 'text': value});
              });

              TextController.clear();
            }
          },
        )
      ],
    );
  }
}
