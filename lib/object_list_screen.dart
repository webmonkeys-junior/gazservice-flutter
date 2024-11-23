import 'package:flutter/material.dart';


class ObjectListScreen extends StatelessWidget {
  const ObjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список объектов')),
      body: const Center(child: Text('Здесь будет список объектов')),
    );
  }
}