// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/createhome1.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'createhome3.dart';

void main() {
  runApp(const MaterialApp(
    home: CreateHome2(
      homeId: '',
    ),
  ));
}

class CreateHome2 extends StatefulWidget {
  // const CreateHome2({super.key});
  final String homeId;

  const CreateHome2({super.key, required this.homeId});

  @override
  _CreateHome2State createState() => _CreateHome2State();
}

class _CreateHome2State extends State<CreateHome2> {
  final TextEditingController _typeAheadController = TextEditingController();
  String? selectedLocation;
  String? selectedLocalization;
  LatLng? selectedLatLng;

  Future<List<String>> _getLocationSuggestions(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      return results.map<String>((result) {
        final address = result['display_name'];
        return address.toString();
      }).toList();
    } else {
      throw Exception('Failed to load location suggestions');
    }
  }

  Future<LatLng?> _getLocationCoordinates(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=1'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      if (results.isNotEmpty) {
        final lat = double.parse(results[0]['lat']);
        final lon = double.parse(results[0]['lon']);
        return LatLng(lat, lon);
      } else {
        throw Exception('No results found');
      }
    } else {
      throw Exception('Failed to load location suggestions');
    }
  }

  Future<void> _sendLocationData() async {
    if (selectedLocation == null ||
        selectedLatLng == null ||
        selectedLocalization == null) {
      // Handle cases where necessary information is missing
      return;
    }

    final url =
        Uri.parse('https://your-api-url/homes/${widget.homeId}/location');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'location': selectedLocation,
        'latitude': selectedLatLng!.latitude,
        'longitude': selectedLatLng!.longitude,
        'localization': selectedLocalization,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully sent data to API
    } else {
      // Handle errors
      if (kDebugMode) {
        print('Failed to send location data: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Location Information'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Handle close action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Handle help action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap content with SingleChildScrollView to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Where are you located?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: const InputDecoration(
                    hintText: 'Select Location',
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await _getLocationSuggestions(pattern);
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (String suggestion) async {
                  setState(() {
                    _typeAheadController.text = suggestion;
                    selectedLocation = suggestion;
                  });
                  final coordinates = await _getLocationCoordinates(suggestion);
                  setState(() {
                    selectedLatLng = coordinates;
                  });
                },
                noItemsFoundBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No locations found'),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                color: Colors.grey[300],
                child: selectedLatLng != null
                    ? FlutterMap(
                        options: MapOptions(
                          center: selectedLatLng,
                          zoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: selectedLatLng!,
                                width: 80.0,
                                height: 80.0,
                                builder: (ctx) => const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          "Map View (Select a location above)",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
              ),

              // this good
              const SizedBox(height: 8),
              const Text(
                "Your address is only shared with people that you agreed to exchange with, as outlined in our privacy policy.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                "Localization",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                title: const Text("In the heart of an international site"),
                value: "International site",
                groupValue: selectedLocalization,
                onChanged: (String? value) {
                  setState(() {
                    selectedLocalization = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text(
                    "In the city, with easy access to public transportation"),
                value: "City with transportation",
                groupValue: selectedLocalization,
                onChanged: (String? value) {
                  setState(() {
                    selectedLocalization = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text(
                    "Outside the city, but with easy access to public transportation"),
                value: "Outside city with transportation",
                groupValue: selectedLocalization,
                onChanged: (String? value) {
                  setState(() {
                    selectedLocalization = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text(
                    "Outside the city, without easy access to public transportation"),
                value: "Outside city without transportation",
                groupValue: selectedLocalization,
                onChanged: (String? value) {
                  setState(() {
                    selectedLocalization = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.amber[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateHome1(),
                        ),
                      );
                    },
                    child: const Text("Back"),
                  ),
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
                      //       builder: (context) => const CreateHome3(),
                      //     ),
                      //   );
                      // },
                      onPressed: () async {
                        await _sendLocationData(); // Sending location data to the API
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateHome3(),
                          ),
                        );
                      },
                      child: const Text("Continue"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
