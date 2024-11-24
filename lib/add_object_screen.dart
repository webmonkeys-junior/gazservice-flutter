import 'package:flutter/material.dart';

class AddObjectscreen extends StatelessWidget {
  const AddObjectscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление объектов'),
      ),
      body: Center(
        child: const Text(" this is the Add Object screen"),
      ),
    );
  }
}