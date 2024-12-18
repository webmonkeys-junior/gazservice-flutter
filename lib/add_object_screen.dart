import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class AddObjectScreen extends StatefulWidget {
  const AddObjectScreen({Key? key}) : super(key: key);

  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _address;
  String? name;
  Position? _currentPosition;
  String? description;
  String? work;
  double? amount;
  List<File> _images = [];
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://gaz-api.webmonkeys.ru/works'),
      );

      request.fields['name'] = name!;
      request.fields['geo'] = _currentPosition != null
          ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}'
          : '';
      request.fields['sum'] = amount.toString();
      request.fields['description'] = description ?? "";
      request.fields['work'] = work!;

      for (var image in _images) {
        request.files.add(await http.MultipartFile.fromPath(
          'photos[]',
          image.path,
        ));
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Произошла ошибка при создании работы')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Получение местоположения было отклонено.')),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      final placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      final placemark = placemarks.first;
      final address = '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}';

      setState(() {
        _address = address;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось получить координаты: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Добавление объекта"),
    ),
    body: Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black,
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Form(
    key: _formKey,
    child: Column(
    children: [
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Работа',
    labelStyle: TextStyle(color: Colors.black), // Цвет названия поля
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0), // Закругленные углы
    borderSide: BorderSide(color: Colors.white), // Белый контур
    ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Введите краткое описание работы';
      }
      return null;
    },
      onSaved: (value) => name = value,
    ),
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Описание',
          labelStyle: TextStyle(color: Colors.black), // Цвет названия поля
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0), // Закругленные углы
            borderSide: BorderSide(color: Colors.white), // Белый контур
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Введите описание работы';
          }
          return null;
        },
        onSaved: (value) => description = value,
      ),
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Рабочие',
          labelStyle: TextStyle(color: Colors.black), // Цвет названия поля
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0), // Закругленные углы
            borderSide: BorderSide(color: Colors.white), // Белый контур
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Введите Фамилию И.О. исполняющих работы';
          }
          return null;
        },
        onSaved: (value) => work = value,
      ),
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Стоимость',
          labelStyle: TextStyle(color: Colors.black), // Цвет названия поля
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0), // Закругленные углы
            borderSide: BorderSide(color: Colors.white), // Белый контур
          ),
        ),
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        onPressed: _pickImage,
        child: const Text('Сделать фото'),
      ),
      const SizedBox(height: 40),
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
      // Рамка для адреса
      if (_address != null)
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Адрес:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8.0),
              Text(
                _address!,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      const SizedBox(height: 20),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        onPressed: _isLoading ? null : _submitForm,
        child: const Text('Отправить работу'),
      ),
    ],
    ),
    ),
    ),
    ),
    ),
    );
  }
}