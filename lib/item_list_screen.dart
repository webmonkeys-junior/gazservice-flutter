import 'package:flutter/material.dart';
import 'package:gazservice/edit_object_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'item.dart'; // Make sure you have this item class defined
import 'work_screen.dart'; // Import your WorkScreen here
import 'add_object_screen.dart'; // Ensure this import is correct
import 'package:intl/intl.dart';
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
      throw Exception('Произошла ошибка при загрузке списка. Проверьте соединение с интернетом.');
    }
  }

  Future<void> _deleteWork(BuildContext context, int itemId) async {
    final response = await http.delete(
      Uri.parse('https://gaz-api.webmonkeys.ru/works/${itemId.toString()}'),
      headers: {
        'Content-Type': 'application/json',
        // Add any required headers here, e.g., authorization
      },
    );
    if (response.statusCode == 200) {
      // Successfully deleted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Работа успешно удалена.')),
      );
      // You might want to refresh the list or navigate back
    } else {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка при удалении работы.')),
      );
    }
    await fetchItems();
  }



    String convertDateTime(String somedate){
      //return dateTime.toLocal().toString(); // Example conversion
      try {
        DateTime dateTime = DateTime.parse(somedate);
        String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
        return formattedDate;
      } catch (e) {
        return somedate;
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Список работ"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(item.name), // Use work as the title
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Выполнено: ${item.work}"),
                  Text("Место: ${item.geo}"), // You may need to modify this field
                  Text("Создано: ${convertDateTime(item.createdAt)}"), // You may need to modify this field
                  Text("Сумма: ${item.sum.toStringAsFixed(2)} \u{20BD} "),
                ],
              ),
              onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => EditObjectScreen(item: item),
          ),
          ).then ((result) {
          if (result == true) {
          fetchItems();
          }
          });

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
                    SnackBar(content: Text('Произошла ошибка. Обратитесь к системному администратору.')),
                  );
                }
              },
              onLongPress: () {
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Удалить работу'),
                    content: Text('Вы уверены, что хотите удалить эту работу?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _deleteWork(context, item.id);
                          Navigator.of(context).pop();
                        },
                        child: Text('Удалить'),
                      ),
                    ],
                  );
                });
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
        tooltip: 'Добавить работу',
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
  final String description;

  Item({
    required this.id,
    required this.name,
    required this.geo,
    required this.createdAt,
    required this.work,
    required this.sum,
    required this.photo,
    required this.description,
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
      description: json['description'] ?? '',
    );
  }
}