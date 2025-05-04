import 'package:assignment2/BloC/Event_Bloc/Event_bloc.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_events.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_state.dart';
import 'package:assignment2/Model/EventDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assignment2/widgets/Comments.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;
  final bool isEdit;
  final String? id;

  const EventDetailScreen({
    super.key,
    required this.event,
    this.isEdit = false,
    this.id,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late TextEditingController eventNameController;
  late TextEditingController eventAuthorController;
  late TextEditingController categoryController;
  late TextEditingController venueController;
  late TextEditingController dateController;
  late TextEditingController timingController;
  late TextEditingController rsvpController;

  @override
  void initState() {
    super.initState();

    eventNameController = TextEditingController(text: widget.event.eventName);
    eventAuthorController =
        TextEditingController(text: widget.event.eventAuthor);
    categoryController = TextEditingController(text: widget.event.category);
    venueController = TextEditingController(text: widget.event.venue);
    dateController = TextEditingController(text: widget.event.date);
    timingController = TextEditingController(text: widget.event.timing);
    rsvpController = TextEditingController(text: widget.event.rsvp);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEdit) {
        context.read<EventBloc>().add(ToggleState());
      }
    });
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventAuthorController.dispose();
    categoryController.dispose();
    venueController.dispose();
    dateController.dispose();
    timingController.dispose();
    rsvpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventUpdated) {
          Fluttertoast.showToast(
              msg: "Changes saved successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pop(context, true);
        }

        if (state is EventUpdatedInitial) {
          eventNameController =
              TextEditingController(text: widget.event.eventName);
          eventAuthorController =
              TextEditingController(text: widget.event.eventAuthor);
          categoryController =
              TextEditingController(text: widget.event.category);
          venueController = TextEditingController(text: widget.event.venue);
          dateController = TextEditingController(text: widget.event.date);
          timingController = TextEditingController(text: widget.event.timing);
          rsvpController = TextEditingController(text: widget.event.rsvp);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(eventNameController.text),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.event.image,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                // Event Title
                widget.isEdit
                    ? TextField(
                        controller: eventNameController,
                        decoration:
                            const InputDecoration(labelText: 'Event Name'),
                      )
                    : Text(
                        eventNameController.text,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 10),

                // Author
                widget.isEdit
                    ? TextField(
                        controller: eventAuthorController,
                        decoration: const InputDecoration(labelText: 'Author'),
                      )
                    : Text('Hosted by: ${eventAuthorController.text}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87)),

                const SizedBox(height: 4),

                // Category
                widget.isEdit
                    ? TextField(
                        controller: categoryController,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                      )
                    : Text('Category: ${categoryController.text}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54)),

                const SizedBox(height: 20),

                // Venue
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: widget.isEdit
                          ? TextField(
                              controller: venueController,
                              decoration:
                                  const InputDecoration(labelText: 'Venue'),
                            )
                          : Text(venueController.text,
                              style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Date
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    widget.isEdit
                        ? Expanded(
                            child: TextField(
                              controller: dateController,
                              decoration:
                                  const InputDecoration(labelText: 'Date'),
                            ),
                          )
                        : Text(dateController.text,
                            style: const TextStyle(fontSize: 16)),
                  ],
                ),

                const SizedBox(height: 10),

                // Timing
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    widget.isEdit
                        ? Expanded(
                            child: TextField(
                              controller: timingController,
                              decoration:
                                  const InputDecoration(labelText: 'Timing'),
                            ),
                          )
                        : Text(timingController.text,
                            style: const TextStyle(fontSize: 16)),
                  ],
                ),

                const SizedBox(height: 30),

                // RSVP and Save Button
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: "Event Host Number: ${rsvpController.text}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('RSVP Call'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: "Host Virtually Notified!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          icon: const Icon(Icons.ads_click),
                          label: const Text('RSVP Virtually'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (widget.isEdit)
                      const SizedBox(
                        height: 10,
                      ),
                    if (widget.isEdit)
                      ElevatedButton.icon(
                        onPressed: () {
                          final updatedEvent = EventModel(
                            eventName: eventNameController.text,
                            eventAuthor: eventAuthorController.text,
                            category: categoryController.text,
                            venue: venueController.text,
                            date: dateController.text,
                            timing: timingController.text,
                            rsvp: rsvpController.text,
                            image: widget.event.image,
                            authorId: widget.event.authorId,
                            id: widget.event.id,
                          );

                          context
                              .read<EventBloc>()
                              .add(UpdateEvent(updatedEvent));
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Save Changes'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (state is EventLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),

                if (!widget.isEdit) ...[
                  const SizedBox(height: 30),
                  CommentsSection(event_id: widget.id),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
