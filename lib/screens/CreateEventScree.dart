import 'package:assignment2/BloC/Auth_Bloc.dart';
import 'package:assignment2/BloC/Auth_state.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_bloc.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_events.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_state.dart';
import 'package:assignment2/Model/EventDataModel.dart';
import 'package:assignment2/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController eventName = TextEditingController();
  TextEditingController venue = TextEditingController();
  TextEditingController author = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController rsvp = TextEditingController();

  String selectedCategory = 'Politics';

  final categories = ['Politics', 'Art', 'Music', 'Technology'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    eventName.dispose();
    venue.dispose();
    author.dispose();
    date.dispose();
    time.dispose();
    rsvp.dispose();
    super.dispose();
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventCreated) {
          Fluttertoast.showToast(
            msg: "Event Created",
            textColor: Colors.white,
            fontSize: 16.0,
            backgroundColor: Colors.green,
            gravity: ToastGravity.TOP,
          );
          Navigator.pop(context, true);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Create Event'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: ListView(
                children: [
                  buildField('Event Name', eventName),
                  buildField('Venue', venue),
                  buildField('Author', author),
                  buildField('Date (e.g. 10/12/25)', date),
                  buildField('Time (e.g. 10AM - 6PM)', time),
                  buildField('RSVP', rsvp),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedCategory = value!),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return BlueButton(
                        title: "Add Event",
                        onPressed: () {
                          if (state is Authenticated) {
                            final event = EventModel(
                              eventName: eventName.text,
                              category: selectedCategory,
                              venue: venue.text,
                              eventAuthor: author.text,
                              date: date.text,
                              timing: time.text,
                              rsvp: rsvp.text,
                              image: 'assets/images/default.jpg',
                              authorId: state.userid,
                            );

                            context.read<EventBloc>().add(CreateEvent(event));
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  if (state is EventLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
