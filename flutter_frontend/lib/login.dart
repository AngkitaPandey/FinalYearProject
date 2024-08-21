import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON handling
import 'homepage.dart'; // For JSON handling

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_validateEmail(email) && _validatePassword(password)) {
      // setState(() {
      //   _isLoading = true;
      // });
      try {
        if (kDebugMode) {
          print(
              'Attempting to login with email: $email and password: $password');
        }
        final response = await http.post(
          Uri.parse('http://10.0.2.2:5000/login'), // Adjust the URL as needed
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
          }),
        );

        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        } // Debug print
        if (kDebugMode) {
          print('Response body: ${response.body}');
        } // Debug print

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          _showMessage('Login Successful', responseData['message'], true);
        } else {
          final responseData = jsonDecode(response.body);
          _showMessage('Login Failed', responseData['error'], false);
        }
      } catch (e) {
        _showMessage('Error', 'An error occurred. Please try again.', false);
      }
      // finally {
      //After the async operation, reset the loading state
      // setState(() {
      //   _isLoading = false;
      // });
      // }
    } else {
      _showMessage(
          'Validation Error', 'Please check your email and password.', false);
    }
  }

  void _showMessage(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              // if (isSuccess) {
              //   // Navigate to the homepage on successful login
              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           const HomePage(),
              //     ),
              //   );
              // }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomePage(), // Replace with your homepage widget
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
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
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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
                      // onPressed: _isLoading
                      //     ? null
                      //     : _login, //Disable the button when loading
                      // child: _isLoading
                      //     ? const SizedBox(
                      //         height: 24.0,
                      //         width: 24.0,
                      //         child: CircularProgressIndicator(
                      //           valueColor:
                      //               AlwaysStoppedAnimation<Color>(Colors.white),
                      //           strokeWidth: 2.0,
                      //         ),
                      //       )
                      onPressed: _login,
                      child: const Text('Login'),
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
