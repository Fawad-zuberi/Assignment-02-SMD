import 'package:assignment2/BloC/Auth_Bloc.dart';
import 'package:assignment2/BloC/Auth_state.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_bloc.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_events.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_state.dart';
import 'package:assignment2/Model/EventDataModel.dart';
import 'package:assignment2/screens/ProfileScreen.dart';
import 'package:assignment2/widgets/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> with RouteAware {
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(FetchEventsAll());
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  // }

  // @override
  // void dispose() {
  //   routeObserver.unsubscribe(this);
  //   super.dispose();
  // }

  // @override
  // void didPopNext() {
  //   context.read<EventBloc>().add(FetchEventsAll());
  // }

  List<EventModel> filterEvents(List<EventModel> events) {
    if (selectedCategory == 'All') return events;
    return events.where((event) => event.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<EventBloc, EventState>(
          builder: (context, eventState) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (authState is! Authenticated) {
                    Fluttertoast.showToast(
                      msg: "Please Login to Continue",
                      textColor: Colors.white,
                      fontSize: 16.0,
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.TOP,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    ).then((_) {
                      context.read<EventBloc>().add(FetchEventsAll());
                    });
                  }
                },
                child: const Icon(Icons.post_add_rounded, size: 30),
              ),
              appBar: AppBar(
                shadowColor: Colors.black,
                foregroundColor: Colors.white,
                title: const Text('Upcoming Events',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blueAccent,
                actions: [
                  if (authState is Authenticated)
                    IconButton(
                      icon: const Icon(Icons.person_2_rounded,
                          color: Colors.black, size: 40),
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
                  // Category filter bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'All',
                          'Music',
                          'Technology',
                          'Art',
                          'Politics'
                        ]
                            .map(
                              (category) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        selectedCategory == category
                                            ? Colors.blueAccent
                                            : const Color.fromARGB(
                                                255, 183, 179, 179),
                                    elevation: 10,
                                    shadowColor: Colors.black,
                                  ),
                                  child: Text(category,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (eventState is EventLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (eventState is EventFetchError) {
                          return Center(
                              child: Text('Error: ${eventState.msg}'));
                        }

                        if (eventState is EventFetched) {
                          final filtered = filterEvents(eventState.Event);
                          if (filtered.isEmpty) {
                            return const Center(
                                child:
                                    Text("No events found in this category."));
                          }
                          return ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              return EventCard(event: filtered[index]);
                            },
                          );
                        }

                        return const Center(child: Text("Fetching events..."));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
