// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'homepage.dart'; // For JSON handling

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_validateName(firstName) &&
        _validateName(lastName) &&
        _validateEmail(email) &&
        _validatePassword(password)) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse(
              'http://10.0.2.2:5000/register'), // Adjust the URL as needed
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Registration Successful'),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to the homepage
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          // Show error message
          final responseData = jsonDecode(response.body);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Registration Failed'),
              content: Text(responseData['error']),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // Handle exceptions
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } finally {
        // Reset the loading state
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Show validation error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Validation Error'),
          content: const Text('Please check your input fields.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  bool _validateName(String first_name) {
    return first_name.isNotEmpty;
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Welcome Page.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.9), // Slightly transparent background
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24.0)), // Border radius on top
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(
                        0, -5), // Shadow to make it look like emerging
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Register Form',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _lastNameController,
                    labelText: 'Last Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.amber[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                      ),
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
