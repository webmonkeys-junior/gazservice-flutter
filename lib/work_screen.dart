import 'package:flutter/material.dart'; // Для использования виджетов Flutter
import 'package:gazservice/item_list_screen.dart';
import 'package:http/http.dart' as http; // Для выполнения HTTP-запросов
import 'dart:convert';

import 'item.dart'; // Для работы с JSON


class WorkScreen extends StatefulWidget {
  final int itemId;

  const WorkScreen({
    required this.itemId,
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
    // _data = ItemData(
    //   id: widget.itemId, // Assuming itemId is of type String
    //   name: "",          // Initialize with empty strings or appropriate default values
    //   geo: "",
    //   createdAt: "",
    //   work: "",
    //   sum: 0,
    //   photo: "",
    // );
    _data = fetchData();
  }

  Future<ItemData> fetchData() async {
    final response = await http.get(Uri.parse('https://gaz-api.webmonkeys.ru/works/${widget.itemId.toString()}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return ItemData.fromJson(jsonResponse);
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
                  Text("Address: ${item.geo}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Geolocation: ${item.geo}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Time: ${item.createdAt}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Amount: \$${item.sum.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
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