import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'item.dart'; // Make sure you have this item class defined
import 'work_screen.dart'; // Import your WorkScreen here
import 'add_object_screen.dart'; // Ensure this import is correct

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems(); // Fetch items when the screen is initialized
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse('https://gaz-api.webmonkeys.ru/works'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("Fetched items: $jsonResponse"); // Debugging line
      setState(() {
        items = jsonResponse.map((data) => Item.fromJson(data)).toList();
      });
    } else {
      print("Failed to load items: ${response.statusCode}"); // Debugging line
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item List"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(item.work), // Use work as the title
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address: ${item.geo}"), // You may need to modify this field
                  Text("Time: ${item.createdAt}"), // You may need to modify this field
                  Text("Amount: ${item.sum.toStringAsFixed(2)} "),
                ],
              ),
              onTap: () {
                if (item.id != null && item.name != null && item.geo != null && item.createdAt != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkScreen(
                        itemId: item.id,
                      ),
                    ),
                  );
                } else {
                  // Handle the error case, e.g., show a snackbar or alert
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Some data is missing.')),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddObjectScreen(),
            ),
          );

          // Check if the result is true, which indicates a successful addition
          if (result == true) {
            // Optionally, you could re-fetch or refresh the items here
            fetchItems(); // Refresh the list after adding a new item
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Object',
      ),
    );
  }
}

class Item {
  final int id; // Changed to int based on API response
  final String name;
  final String geo; // Changed to geo based on API response
  final String createdAt; // Added createdAt field
  final String work; // Added work field
  final double sum; // Changed to double based on API response
  final String photo; // Added photo field (if needed)

  Item({
    required this.id,
    required this.name,
    required this.geo,
    required this.createdAt,
    required this.work,
    required this.sum,
    required this.photo,
  });

  // Factory constructor to create an Item from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'] ?? '',
      geo: json['geo'] ?? '',
      createdAt: json['created_at'] ?? '', // Ensure you format this if needed
      work: json['work'] ?? '',
      sum: json['sum'] ?? '',
      photo: json['photo'] ?? '', // If you want to use this field later
    );
  }
}