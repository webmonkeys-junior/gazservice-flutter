import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkScreen extends StatefulWidget {
  final String itemId;

  const WorkScreen({required this.itemId, Key? key}) : super(key: key);

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late Future<void> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://gaz-api.webmonkeys.ru/items/${widget.itemId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Screen"),
      ),
      body: FutureBuilder<void>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: Text("Data loaded successfully!"));
        },
      ),
    );
  }
}