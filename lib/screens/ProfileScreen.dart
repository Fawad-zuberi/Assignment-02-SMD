import 'package:assignment2/BloC/Profile_Bloc/Profile_Bloc.dart';
import 'package:assignment2/BloC/Profile_Bloc/Profile_Event.dart';
import 'package:assignment2/BloC/Profile_Bloc/Profile_State.dart';
import 'package:assignment2/Model/UserDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment2/BloC/Auth_Bloc.dart';
import 'package:assignment2/BloC/Auth_events.dart';
import 'package:assignment2/BloC/Auth_state.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_bloc.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_events.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_state.dart';
import 'package:assignment2/screens/DetailView.dart';
import 'package:assignment2/screens/HomePage.dart';
import 'package:assignment2/widgets/Button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _professionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _controllersInitialized = false;

  void _initializeControllers(Authenticated user) {
    _firstNameController.text = user.user.firstName;
    _lastNameController.text = user.user.lastName;
    _professionController.text = user.user.profession;
    _phoneController.text = user.user.phone;
    _emailController.text = user.user.email;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _professionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final isReadOnly = state is! ProfileIsEdit;
        return TextField(
          controller: controller,
          readOnly: isReadOnly,
          obscureText: isPassword,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated && !_controllersInitialized) {
          _initializeControllers(state);
          _controllersInitialized = true;
        }

        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
                actions: [
                  if (state is ProfileInitial)
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        context.read<ProfileBloc>().add(isToggle());
                      },
                    ),
                  if (state is ProfileIsEdit)
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;

                        final updatedUser = Userdatamodel(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          profession: _professionController.text.trim(),
                          phone: _phoneController.text.trim(),
                          email: _emailController.text.trim(),
                        );

                        if (authState is Authenticated) {
                          context
                              .read<ProfileBloc>()
                              .add(ProfileSave(updatedUser, authState.userid));
                        }
                        Fluttertoast.showToast(
                          msg: "Updated Success",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      },
                    )
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTextField("First Name", _firstNameController),
                    const SizedBox(height: 10),
                    _buildTextField("Last Name", _lastNameController),
                    const SizedBox(height: 10),
                    _buildTextField("Profession", _professionController),
                    const SizedBox(height: 10),
                    _buildTextField("Phone", _phoneController),
                    const SizedBox(height: 10),
                    _buildTextField("Email", _emailController),
                    const SizedBox(height: 20),
                    BlueButton(
                      title: "Logout",
                      onPressed: () {
                        context.read<AuthBloc>().add(Logout());
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Events",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<EventBloc, EventState>(
                      builder: (context, state) {
                        if (state is EventLoading) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is EventFetchError) {
                          return Text("Error: ${state.msg}");
                        }

                        if (state is! EventFetchedSpecific) {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is Authenticated) {
                            context
                                .read<EventBloc>()
                                .add(FetchEventsSepcific(authState.userid));
                          }

                          return const SizedBox();
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.Event.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final eventfetched = state.Event[index];
                            return ListTile(
                              title: Text(eventfetched.eventName),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailScreen(
                                      event: eventfetched,
                                      isEdit: true,
                                      id: eventfetched.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
