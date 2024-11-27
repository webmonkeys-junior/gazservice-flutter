import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';

class AddObjectScreen extends StatefulWidget {
  const AddObjectScreen({Key? key}) : super(key: key);

  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  Position? _currentPosition; // Variable to hold the current position
  String? time;
  double? amount;
  List<File> _images = []; // List to hold the selected images

  final ImagePicker _picker = ImagePicker();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create FormData
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://gaz-api.webmonkeys.ru/works'), // Replace with your API endpoint
      );

      request.fields['name'] = name!;
      request.fields['address'] = _currentPosition != null
          ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}' // Use null-aware operator
          : ''; // Fallback if position is null
      request.fields['time'] = time!;
      request.fields['amount'] = amount.toString();

      // Add all selected images to the request
      for (var image in _images) {
        request.files.add(await http.MultipartFile.fromPath(
          'photos[]', // This should match your backend's expected field name
          image.path,
        ));
      }

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, navigate back
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add object')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera, // Change to ImageSource.gallery if you want to pick from gallery
      imageQuality: 100, // You can adjust the quality
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path)); // Add the new image to the list
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // Handle permission denied or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Object"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => name = value,
              ),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('Get Current Location'),
              ),
              if (_currentPosition != null)
                Text(
                  'Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}', // Use null-aware operator
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
                onSaved: (value) => time = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                onSaved: (value) => amount = value != null ? double.tryParse(value) : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              // Display all selected images
              Wrap(
                spacing: 8.0,
                children: _images.map((image) {
                  return Container(
                    height: 150,
                    width: 150,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}