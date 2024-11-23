import 'package:flutter/material.dart';

import 'dart:convert';

class ObjectListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Список объектов')),
      body: Center(child: Text('Здесь будет список объектов')),
    );
  }
}