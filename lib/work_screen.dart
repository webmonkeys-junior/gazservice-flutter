import 'package:flutter/material.dart'; // Для использования виджетов Flutter
import 'package:http/http.dart' as http; // Для выполнения HTTP-запросов
import 'dart:convert';

import 'item.dart'; // Для работы с JSON


class WorkScreen extends StatefulWidget {
  final String itemId;
  final String name;
  final String geolocation;
  final double amount;
  final String time;

  const WorkScreen({
    required this.itemId,
    required this.name,
    required this.geolocation,
    required this.amount,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late Future<ItemData> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<ItemData> fetchData() async {
    final response = await http.get(Uri.parse('https://gaz-api.webmonkeys.ru/works/${widget.itemId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ItemData.fromJson(data);
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
      body: FutureBuilder<ItemData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final item = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${item.id}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Name: ${widget.name}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Address: ${item.address}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Geolocation: ${widget.geolocation}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Time: ${widget.time}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Amount: \$${widget.amount.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}