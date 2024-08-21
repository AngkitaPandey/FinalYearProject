import 'package:flutter/material.dart';
import 'signup.dart'; //Import the register page
import 'login.dart'; //Import the login page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        '/register': (context) =>
            const RegisterPage(), // Define the route for the register page
        '/login': (context) =>
            const LoginPage(), // Define the route for the register page
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Welcome Page.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with text and buttons
          Container(
            height: height,
            width: width,
            color: Colors.black.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: height * 0.1),
                  // Title
                  Text(
                    'HomeSwap',
                    style: TextStyle(
                      fontSize: height * 0.05,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  // Main content
                  Column(
                    children: [
                      // Subtitle
                      Text(
                        'Swap and Stay',
                        style: TextStyle(
                          fontSize: height * 0.04,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        'Find your perfect trade',
                        style: TextStyle(
                          fontSize: height * 0.025,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      // Get Started Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              '/register'); // Navigate to the register page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.2,
                            vertical: height * 0.02,
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: height * 0.025,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      // Log in link
                      GestureDetector(
                        onTap: () {
                          // Handle the "Log in" tap
                          Navigator.pushNamed(
                              context, '/login'); // Navigate to the login page
                        },
                        child: Text(
                          'Already have an account? Log in',
                          style: TextStyle(
                            fontSize: height * 0.02,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
