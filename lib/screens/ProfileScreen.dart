import 'package:assignment2/BloC/Auth_Bloc.dart';
import 'package:assignment2/BloC/Auth_events.dart';
import 'package:assignment2/BloC/Auth_state.dart';
import 'package:assignment2/screens/DetailView.dart';
import 'package:assignment2/screens/HomePage.dart';
import 'package:assignment2/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController(text: "John");
  final _lastNameController = TextEditingController(text: "Doe");
  final _professionController =
      TextEditingController(text: "Software Engineer");
  final _phoneController = TextEditingController(text: "+1 234 567 890");
  final _emailController = TextEditingController(text: "john.doe@example.com");
  final _passwordController = TextEditingController(text: "password123");

  bool isEditing = false;

  final List<Map<String, String>> myEvents = [
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
      'eventName': '2',
      'category': 'Art',
      'venue': 'Louvre Museum',
      'eventAuthor': 'Marie Curie',
      'date': '10/12/25',
      'timing': '10:00 AM - 6:00 PM',
      'rsvp': '321-654-9870',
      'image': 'assets/images/art.jpeg'
    },
  ];

  void _saveProfile() {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final profession = _professionController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
  }

  void _toggleEdit() {
    setState(() {
      if (isEditing) _saveProfile();
      isEditing = !isEditing;
    });
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      readOnly: !isEditing,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            actions: [
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                onPressed: _toggleEdit,
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTextField("First Name", _firstNameController, false),
                const SizedBox(height: 10),
                _buildTextField("Last Name", _lastNameController, false),
                const SizedBox(height: 10),
                _buildTextField("Profession", _professionController, false),
                const SizedBox(height: 10),
                _buildTextField("Phone", _phoneController, false),
                const SizedBox(height: 10),
                _buildTextField("Email", _emailController, false),
                const SizedBox(height: 10),
                _buildTextField("Password", _passwordController, true),
                const SizedBox(height: 10),
                BlueButton(
                    title: "Logout",
                    onPressed: () => {
                          context.read<AuthBloc>().add(Logout()),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()))
                        }),
                const SizedBox(height: 20),
                const Divider(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: myEvents.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final Map<String, String> event = myEvents[index];
                    return ListTile(
                      title: Text(event['eventName']!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailScreen(
                              event: event,
                              isEdit: true,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
