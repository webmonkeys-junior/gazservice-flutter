import 'package:flutter/material.dart';
import 'item.dart';
import 'work_screen.dart';

class ItemListScreen extends StatelessWidget {
  final List<Item> items = [
    Item(id: "-1", time: "10:00 AM", name: "Komar", address: "Shestakovo", amount: 100.0),
    Item(id: "-1", time: "11:00 AM", name: "KOmar", address: "Shestakovo", amount: 150.0),
    Item(id: "-1", time: "12:00 PM", name: "CUMar", address: "Shestakovo", amount: 200.0),
    // Add more items as needed
  ];

  ItemListScreen({super.key});

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
              title: Text(item.name),
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
                    builder: (context) => WorkScreen(itemId: item.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}