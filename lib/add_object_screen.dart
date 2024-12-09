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
  //String? time;
  String? description;
  String? work;
  double? amount;
  List<File> _images = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create FormData
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://gaz-api.webmonkeys.ru/works'), // Replace with your API endpoint
      );

      request.fields['name'] = name!;
      request.fields['geo'] = _currentPosition != null
          ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}' // Use null-aware operator
          : ''; // Fallback if position is null
      //request.fields['time'] = time!;
      request.fields['sum'] = amount.toString();
      request.fields['description'] = "";
      request.fields['work'] = work!;

      for (var image in _images) {
        request.files.add(await http.MultipartFile.fromPath(
          'photos[]',
          image.path,
        ));
      }

      // Send the request
      final response = await request.send();

      if (response.statusCode == 201) {
        // If the server returns a 200 OK response, navigate back
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        final responseBody = await response.stream.bytesToString(); // Get the response body as a string
        print('******************');
        print('Status Code: ${response.statusCode}');
        print('Response Body: $responseBody');
        print('******************');
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Произошла ошибка при создании работы')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera, // Change to ImageSource.gallery if you want to pick from gallery
      imageQuality: 80, // You can adjust the quality
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Получение местоположения было отклонено. Зайдите в настройки приложения и разрешите')),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // Handle permission denied or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось получить координаты: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Новая работа"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Работа'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите краткое описание работы';
                    }
                    return null;
                  },
                  onSaved: (value) => name = value,
                ),
                if (_currentPosition != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Текущие координаты: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  TextFormField(
                  decoration: const InputDecoration(labelText: 'Описание'),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Введите описание работы';
                  }
                  return null;
                  },
                  onSaved: (value) => description = value,
                  ),
                  TextFormField(
                  decoration: const InputDecoration(labelText: 'Рабочие'),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Введите Фамилию И.О. исполняющих работы';
                  }
                  return null;
                  },
                  onSaved: (value) => work = value,
                  ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Стоимость'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите стоимость работ';
                    }
                    return null;
                  },
                  onSaved: (value) => amount = value != null ? double.tryParse(value) : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Сделать фото'),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  children: _images.map((image) {
                    return Card(
                      elevation: 4,
                      child: Container(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Отправить работу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}