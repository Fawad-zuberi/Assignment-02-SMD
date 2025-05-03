import 'package:assignment2/BloC/Auth_Bloc.dart';
import 'package:assignment2/BloC/Auth_events.dart';
import 'package:assignment2/BloC/Auth_state.dart';
import 'package:flutter/material.dart';
import 'package:assignment2/widgets/Button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _professionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _professionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      bool obscure = false,
      TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Fluttertoast.showToast(
            msg: "Account created for ${_firstNameController.text}",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            gravity: ToastGravity.TOP,
          );
          Navigator.pop(context, true);
        }
        if (state is Unauthenticated) {
          Fluttertoast.showToast(
            msg: "${state.error}",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              title: const Text('Sign Up'),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                        controller: _firstNameController, hint: 'First Name'),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _lastNameController, hint: 'Last Name'),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _professionController, hint: 'Profession'),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        type: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _emailController,
                        hint: 'Email',
                        type: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscure: true),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _rePasswordController,
                        hint: 'Re-enter Password',
                        obscure: true),
                    const SizedBox(height: 25),
                    BlueButton(
                        title: "Sign Up",
                        onPressed: () => {
                              context.read<AuthBloc>().add(SignUpEvent(
                                    _firstNameController.text.trim(),
                                    _lastNameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    _professionController.text.trim(),
                                    _phoneController.text.trim(),
                                    _passwordController.text.trim(),
                                    _rePasswordController.text.trim(),
                                  ))
                            }),
                    const SizedBox(height: 5),
                    if (state is AuthLoading)
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
      ),
    );
  }
}
