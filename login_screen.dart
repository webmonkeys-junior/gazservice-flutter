import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    // Логика регистрации
    print('Регистрация: ${_usernameController.text}, ${_emailController.text}, ${_passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundedTextField(_usernameController, 'Имя пользователя'),
            const SizedBox(height: 16),
            _buildRoundedTextField(_emailController, 'Электронная почта'),
            const SizedBox(height: 16),
            _buildRoundedTextField(_passwordController, 'Пароль', obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.blue, width: 2.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        ),
        obscureText: obscureText,
      ),
    );
  }
}