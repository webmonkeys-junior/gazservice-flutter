import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddObjectScreen extends StatefulWidget {
  const AddObjectScreen({Key? key}) : super(key: key);

  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? address;
  String? time;
  double? amount;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create FormData
      var formData = {
        'name': name,
        'address': address,
        'time': time,
        'amount': amount.toString(),
      };

      // Send POST request
      final response = await http.post(
        Uri.parse('http://gaz-api.webmonkeys.ru/works'), // Replace with your API endpoint
        body: formData,
      );

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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onSaved: (value) => address = value,
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
                onSaved: (value) => amount = double.tryParse(value!),
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