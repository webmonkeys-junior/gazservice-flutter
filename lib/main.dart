import 'package:flutter/material.dart';
import 'package:gazservice/item_list_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('https://gaz-api.webmonkeys.ru/login'), // Change to your server URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _email,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => ItemListScreen(),
      ));
      // Успешный вход

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('КАЙФ!')),
      );
    } else {
      // Ошибка входа
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('НЕ КАЙФ')),
      );
    }
  }

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse(' https://gaz-api.webmonkeys.ru'), // Change to your server URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _email,
        'password': _password,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
                 context,
               MaterialPageRoute(builder: (context) => ItemListScreen()),
         );


      // Успешная регистрация
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),

      );
    } else {
      // Ошибка регистрации
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login and Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _register();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
