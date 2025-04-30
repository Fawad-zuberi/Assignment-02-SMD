import 'package:assignment2/screens/CreateEventScree.dart';
import 'package:assignment2/screens/ProfileScreen.dart';
import 'package:assignment2/widgets/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final List<Map<String, String>> allEvents = [
    {
      'eventName': 'Music Concert',
      'category': 'Music',
      'venue': 'Madison Square Garden',
      'date': '10/12/25',
      'eventAuthor': 'John Doe',
      'timing': '8:00 PM - 11:00 PM',
      'rsvp': '123-456-7890',
      'image': 'assets/images/music.jpg'
    },
    {
      'eventName': 'Tech Conference',
      'category': 'Technology',
      'venue': 'Silicon Valley',
      'eventAuthor': 'Tech Guru',
      'date': '10/12/25',
      'timing': '9:00 AM - 5:00 PM',
      'rsvp': '987-654-3210',
      'image': 'assets/images/tech.jpg'
    },
    {
      'eventName': 'Art Exhibition',
      'category': 'Art',
      'venue': 'Louvre Museum',
      'eventAuthor': 'Marie Curie',
      'date': '10/12/25',
      'timing': '10:00 AM - 6:00 PM',
      'rsvp': '321-654-9870',
      'image': 'assets/images/art.jpeg'
    },
    {
      'eventName': 'ExChairman PTI Video Conference',
      'category': 'Politics',
      'venue': 'PTI Media Platforms',
      'eventAuthor': 'PTI',
      'date': '10/12/25',
      'timing': '10:00 AM - 6:00 PM',
      'rsvp': '321-654-9870',
      'image': 'assets/images/politics.jpeg'
    },
  ];

  final loggedin = true;
  String selectedCategory = 'All';

  List<Map<String, String>> get filteredEvents {
    if (selectedCategory == 'All') {
      return allEvents;
    } else {
      return allEvents
          .where((event) => event['category'] == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!loggedin) {
            Fluttertoast.showToast(
                msg: "Please Login to Continue",
                textColor: Colors.white,
                fontSize: 16.0,
                backgroundColor: Colors.red,
                gravity: ToastGravity.TOP);
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEventScreen()));
          }
        },
        child: Icon(
          Icons.post_add_rounded,
          size: 30,
        ),
      ),
      appBar: AppBar(
        shadowColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Upcoming Events',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (loggedin)
            IconButton(
              icon: const Icon(
                Icons.person_2_rounded,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: ['All', 'Music', 'Technology', 'Art', 'Politics']
                      .map((category) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedCategory == category
                                      ? Colors.blueAccent
                                      : const Color.fromARGB(
                                          255, 183, 179, 179),
                                  elevation: 10,
                                  shadowColor: Colors.black),
                              child: Text(
                                category,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return EventCard(
                  event: event,
                  islogged: loggedin,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
