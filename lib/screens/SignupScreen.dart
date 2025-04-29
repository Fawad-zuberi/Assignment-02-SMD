import 'package:flutter/material.dart';
import 'package:assignment2/widgets/Button.dart'; // Reusing your custom button
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

  void _handleSignUp() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _professionController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _rePasswordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Fluttertoast.showToast(
      msg: "Account created for ${_firstNameController.text}",
      backgroundColor: Colors.green,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
    );
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
              BlueButton(title: "Sign Up", onPressed: _handleSignUp),
            ],
          ),
        ),
      ),
    );
  }
}
