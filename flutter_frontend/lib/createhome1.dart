// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'createhome2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    home: CreateHome1(),
  ));
}

class CreateHome1 extends StatefulWidget {
  const CreateHome1({super.key});

  @override
  CreateHome1State createState() => CreateHome1State();
}

// ignore: camel_case_types
class CreateHome1State extends State<CreateHome1> {
  bool isMainHome = false;
  String? selectedPropertyType;
  String? selectedRoomTypeApartment;
  String? selectedRoomTypeHouse;

  Future<void> _submitHomeInfo() async {
    try {
      final response = await http.post(
        Uri.parse('https://your-api-url/homes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'propertyType': selectedPropertyType,
          'roomType': selectedPropertyType == "Apartment"
              ? selectedRoomTypeApartment
              : selectedRoomTypeHouse,
          'isMainHome': isMainHome,
        }),
      );

      if (response.statusCode == 200) {
        final homeId = jsonDecode(response.body)['homeId'];
        // Navigate to CreateHome2 page and pass the homeId to it
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateHome2(homeId: homeId),
          ),
        );
      } else {
        // Handle error
        throw Exception('Failed to create home');
      }
    } catch (error) {
      // Handle exception
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Information'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Handle close action
            Navigator.pop(context); //Close the current page
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Handle help action
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Help"),
                    content: const Text(
                        "Please provide detailed information about your home to improve exchanges."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tell Us About Your Home!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Providing detailed information about your home helps improve exchanges! It will only take a few minutes.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Property Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPropertyType = "Apartment";
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedPropertyType == "Apartment"
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.apartment, color: Colors.blue),
                    SizedBox(width: 16),
                    Text(
                      "Apartment",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedPropertyType == "Apartment")
              Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 8),
                child: DropdownButton<String>(
                  value: selectedRoomTypeApartment,
                  hint: const Text("Select Room Type"),
                  items: <String>['Entire Room', 'Private Room']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRoomTypeApartment = newValue;
                    });
                  },
                ),
              ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPropertyType = "House";
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedPropertyType == "House"
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.house, color: Colors.blue),
                    SizedBox(width: 16),
                    Text(
                      "House",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedPropertyType == "House")
              Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 8),
                child: DropdownButton<String>(
                  value: selectedRoomTypeHouse,
                  hint: const Text("Select Room Type"),
                  items: <String>['Entire Room', 'Private Room']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRoomTypeHouse = newValue;
                    });
                  },
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "This is my main home",
                  style: TextStyle(fontSize: 18),
                ),
                Switch(
                  value: isMainHome,
                  onChanged: (value) {
                    setState(() {
                      isMainHome = value;
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.amber[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const CreateHome2(),
                //     ),
                //   );
                // },
                onPressed: _submitHomeInfo,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
