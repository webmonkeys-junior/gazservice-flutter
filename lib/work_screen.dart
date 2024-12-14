import 'package:flutter/material.dart'; // Для использования виджетов Flutter
import 'package:gazservice/item_list_screen.dart';
import 'package:http/http.dart' as http; // Для выполнения HTTP-запросов
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:intl/intl.dart';
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
    _data = fetchData();
  }

  Future<ItemData> fetchData() async {
    final response = await http.get(Uri.parse('https://gaz-api.webmonkeys.ru/works/${widget.itemId.toString()}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return ItemData.fromJson(jsonResponse);
    } else {
      throw Exception('Ошибка при обращении к бэкенду');
    }
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
        title: const Text("Работа"),
      ),
      body: FutureBuilder<ItemData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Опаньки! ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final item = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${item.id}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Работа: ${item.name}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Место: ${item.geo}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Описание: ${item.description}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 30),
                  //Text("Geolocation: ${item.geo}", style: TextStyle(fontSize: 20)),
                  //SizedBox(height: 10),
                  Text("Создано: ${convertDateTime(item.createdAt)}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Сумма: ${item.sum.toStringAsFixed(2)} \u{20BD}", style: TextStyle(fontSize: 20)),
                  if (item.photo.isNotEmpty) // Проверяем, есть ли фото
                    GestureDetector(
                      onTap: () {
                        _showLightbox(context, item.photo);
                      },
                      child: Image.network(
                        'https://gaz-api.webmonkeys.ru/uploads/${item.photo}',
                        width: 100, // Миниатюра
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Return the image when loaded
                          } else {
                            // Show a loading indicator while the image is loading
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          // Handle the error case (e.g., show a placeholder or an error message)
                          return Center(child: Icon(Icons.error)); // Display an error icon
                        },
                      ),
                    ),
                ],
              ),
            );
          }
          return const Center(child: Text("Нет данных"));
        },
      ),
    );
  }
  void _showLightbox(BuildContext context, String photoFilename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewGallery(
          pageOptions: [
            PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage('https://gaz-api.webmonkeys.ru/uploads/$photoFilename'),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ],
          scrollPhysics: BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          pageController: PageController(initialPage: 0),
        ),
      ),
    );
  }
}