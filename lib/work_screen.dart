import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkScreen extends StatelessWidget {
  late final String itemId;

  Workscreen({required this.itemId}) {
    // TODO: implement Workscreen
    throw UnimplementedError();
  }

  Future<void> fetchData()
  async {
    final response = await http.get(Uri.parse('http://gazservice.webmonkeys.ru/items/$itemId'));

    if (response.statusCode == 200) {
      final data =
          json.decode(response.body);
      print(data);
    } else {
      throw
    Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    fetchData();
    return Scaffold(
      appBar: AppBar (
        title: const Text("Work screeen"),
      ),
      body: const Center(
        child: Text("Loading..."),
      ),
    );
  }
}