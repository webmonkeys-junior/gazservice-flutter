import 'package:flutter/material.dart';
import 'register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("GAZSERVICE")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "UserName"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Войти'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {

              },
              child: Text(
                "Нету аккаунта? Зарегистрируйся!",
                style: TextStyle(color: Colors.blue),
              )
            )

          ],
        ),
      ),
    ),
  );
  }
}