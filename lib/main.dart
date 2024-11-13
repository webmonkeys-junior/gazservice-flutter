import 'package:flutter/material.dart';
import 'item_list_screen.dart'; // Import the new screen

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLoginMode = true; // Toggle between login and registration

  void _submit() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_isLoginMode) {
      // Handle login logic
      print('Logging in with email: $email and password: $password');
      // Navigate to the item list after login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ItemListScreen()),
      );
    } else {
      final username = _usernameController.text;
      // Handle registration logic
      print('Registering with username: $username, email: $email, and password: $password');
    }

    // Clear the text fields
    _emailController.clear();
    _passwordController.clear();
    if (!_isLoginMode) {
      _usernameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isLoginMode)
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLoginMode ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode; // Toggle between login and registration
                });
              },
              child: Text(_isLoginMode
                  ? 'Don\'t have an account? Register here.'
                  : 'Already have an account? Login here.'),
            ),
          ],
        ),
      ),
    );
  }
}