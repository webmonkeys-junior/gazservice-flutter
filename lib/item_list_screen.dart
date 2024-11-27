import 'package:flutter/material.dart';
import 'item.dart'; // Make sure you have this item class defined
import 'work_screen.dart'; // Import your WorkScreen here
import 'add_object_screen.dart'; // Ensure this import is correct

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  List<Item> items = [
    Item(
      id: "4",
      time: "10:00 AM",
      name: "Komar",
      address: "Shestakovo",
      amount: 100.0,
      geolocation: "37.7749° N, 122.4194° W",
    ),
    Item(
      id: "3",
      time: "11:00 AM",
      name: "KOmar",
      address: "Shestakovo",
      amount: 150.0,
      geolocation: "34.0522° N, 118.2437° W",
    ),
    Item(
      id: "2",
      time: "12:00 PM",
      name: "CUMar",
      address: "Shestakovo",
      amount: 200.0,
      geolocation: "40.7128° N, 74.0060° W",
    ),
    // Add more items as needed
  ];

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
              title: const Text("Work Screen"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address: ${item.address}"),
                  Text("Time: ${item.time}"),
                  Text("Amount: \$${item.amount.toStringAsFixed(2)}"),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkScreen(
                      itemId: item.id,
                      name: item.name,
                      geolocation: item.geolocation,
                      amount: item.amount,
                      time: item.time,
                    ),
                  ),
                );
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
            setState(() {
              // You can add the new item to the list here if you have the data
              // For example, if you have the new item data, you could do:
              // items.add(newItem);
            });
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Object',
      ),
    );
  }
}

class Item {
  final String id;
  final String name;
  final String address;
  final String time;
  final double amount;
  final String geolocation;

  Item({
    required this.id,
    required this.name,
    required this.address,
    required this.time,
    required this.amount,
    required this.geolocation,
  });
}