// ignore_for_file: unnecessary_nullable_for_final_variable_declarations
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateHome3 extends StatefulWidget {
  const CreateHome3({super.key});

  @override
  _CreateHome3State createState() => _CreateHome3State();
}

class _CreateHome3State extends State<CreateHome3> {
  final List<XFile> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    // Choose multiple images from gallery
    final List<XFile>? selectedImages = await _picker.pickMultiImage();

    if (selectedImages != null) {
      setState(() {
        _imageFiles.addAll(selectedImages);
      });
    }
  }

  // Take a photo using the camera
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _imageFiles.add(photo);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Photos of Your Property"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please upload photos of your property. You can take photos or select from your gallery.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Select from Gallery"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.amber[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take a Photo"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.amber[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _imageFiles.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.file(
                        File(_imageFiles[index].path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the next step here, such as navigating to the next page
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
