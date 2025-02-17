import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Импортируем пакет для работы с SVG
import 'package:gazservice/item_list_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ООО "Газсервис" | Вход',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _login() async {
    String credentials = '$_email:$_password';

    // Encode the credentials in Base64
    String base64Credentials = base64Encode(utf8.encode(credentials));
    final response = await http.post(
      Uri.parse('https://gaz-api.webmonkeys.ru/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic $base64Credentials',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String jwtToken = responseData['access_token'];  // Adjust based on your response structure

      // Store the JWT token in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', jwtToken);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => ItemListScreen(),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вход выполнен успешно')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка входа')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('GAZSERVICE'), // Заголовок
    centerTitle: true,
    ),
    body: Container(
    decoration: BoxDecoration(
    color: Colors.lightBlue,
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    // Добавляем SVG логотип
    SvgPicture.asset(
    'assets/logo.svg',  // Путь к вашему SVG файлу
    height: 120, // Установите нужную высоту
    ),
    const SizedBox(height: 20), // Отступ между логотипом и формой
    Form(
    key: _formKey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Email',
    filled: true,
    fillColor: Colors.black.withOpacity(0.5), // Полупрозрачный черный
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.white, width: 1.0), // Белый контур
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your email';
    }
    return null;
    },
    onChanged: (value) {
    _email = value;
    },
    ),
    const SizedBox(height: 20),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Password',
    filled: true,
    fillColor: Colors.black.withOpacity(0.5), // Полупрозрачный черный
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.white, width: 1.0), // Белый контур
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    ),
    obscureText: true,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your password';
    }
    return null;
    },
      onChanged: (value) {
        _password = value;
      },
    ),
      const SizedBox(height: 80), // Увеличенный отступ
      SizedBox(
        width: double.infinity, // Задает ширину кнопки на всю ширину
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _login();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.7), // Полупрозрачный черный фон
            side: const BorderSide(color: Colors.white, width: 1.0), // Белый контур
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Круглые углы
            ),
          ),
          child: const Text('Login', style: TextStyle(fontSize: 18)),
        ),
      ),
      const SizedBox(height: 10),
    ],
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}