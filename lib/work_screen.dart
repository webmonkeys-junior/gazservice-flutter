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
      return ItemData.fromJson(data); // Преобразование JSON в объект ItemData
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
                  Text("Name: ${item.name}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Address: ${item.address}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Time: ${item.time}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Amount: \$${item.amount.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
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


class ItemData {
  final String id;
  final String name;
  final String address;
  final String time;
  final double amount;

  ItemData({required this.id, required this.name, required this.address, required this.time, required this.amount});

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      time: json['time'],
      amount: json['amount'].toDouble(),
    );
  }
}