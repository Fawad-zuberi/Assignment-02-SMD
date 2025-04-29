import 'package:assignment2/widgets/Button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateEventScreen extends StatefulWidget {
  final Map<String, String>? initialEvent; // only passing if i want to edit

  const CreateEventScreen({super.key, this.initialEvent});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController eventName;
  late TextEditingController venue;
  late TextEditingController author;
  late TextEditingController date;
  late TextEditingController time;
  late TextEditingController rsvp;

  final Map<String, String> categoryImageMap = {
    'Politics': 'assets/images/politics.jpeg',
    'Education': 'assets/images/education.jpeg',
    'Entertainment': 'assets/images/music.jpg',
    'Technology': 'assets/images/tech.jpg',
    'Art': 'assets/images/art.jpeg',
  };

  String selectedCategory = 'Politics';

  final categories = ['Politics', 'Education', 'Entertainment', 'Technology'];

  @override
  void initState() {
    super.initState();
    final e = widget.initialEvent ?? {};

    eventName = TextEditingController(text: e['eventName'] ?? '');
    venue = TextEditingController(text: e['venue'] ?? '');
    author = TextEditingController(text: e['eventAuthor'] ?? '');
    date = TextEditingController(text: e['date'] ?? '');
    time = TextEditingController(text: e['timing'] ?? '');
    rsvp = TextEditingController(text: e['rsvp'] ?? '');
    selectedCategory = e['category'] ?? 'Politics';
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

  void saveEvent() {
    if (_formKey.currentState!.validate()) {
      final imagePath = categoryImageMap[selectedCategory];

      final event = {
        'eventName': eventName.text,
        'venue': venue.text,
        'eventAuthor': author.text,
        'date': date.text,
        'timing': time.text,
        'rsvp': rsvp.text,
        'image': imagePath,
        'category': selectedCategory,
      };

      // debugPrint(event.toString());

      Fluttertoast.showToast(
          msg: widget.initialEvent == null ? "Event Created " : "Event Updated",
          textColor: Colors.white,
          fontSize: 16.0,
          backgroundColor: Colors.green,
          gravity: ToastGravity.TOP);
      Navigator.pop(context, event);
    }
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
    final isEditing = widget.initialEvent != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Event' : 'Create Event'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField('Event Name', eventName),
              buildField('Venue', venue),
              buildField('Author', author),
              buildField('Date (e.g. 10/12/25)', date),
              buildField('Time (e.g. 10AM - 6PM)', time),
              buildField('RSVP', rsvp),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              BlueButton(
                  title: widget.initialEvent == null
                      ? "Add Event"
                      : "Save Changes",
                  onPressed: saveEvent)
            ],
          ),
        ),
      ),
    );
  }
}
