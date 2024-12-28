import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'item.dart';
import 'item_list_screen.dart';

class EditObjectScreen extends StatefulWidget {
  final Item item;

  const EditObjectScreen({Key? key, required this.item}) : super(key: key);

  @override
  _EditObjectScreenState createState() => _EditObjectScreenState();
}

class _EditObjectScreenState extends State<EditObjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String work;
  late String geo;
  late double sum;
  late String description;

  @override
   void initState() {
    super.initState();
    name = widget.item.name;
    work = widget.item.work;
    geo = widget.item.geo;
    sum = widget.item.sum;
    description = widget.item.description;
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await http.put(
        Uri.parse('https://gaz-api.webmonkeys.ru/works/${widget.item.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'work': work,
          'geo': geo,
          'sum': sum,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ошибка при обнаолении работы')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактировать работу"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Работа'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название работы';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: work,
                decoration: InputDecoration(labelText: 'Рабочие'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите Ф.И.О исполняющих работу';
                  }
                  return null;
                },
                onSaved: (value) => work = value!,
              ),
              TextFormField(
                initialValue: geo,
                decoration: InputDecoration(labelText: 'Место'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите место';
                  }
                  return null;
                },
                onSaved: (value) => geo = value!,
              ),
              TextFormField(
                initialValue: sum.toString(),
                decoration: InputDecoration(labelText: 'Стоимость'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите стоимость';
                  }
                  return null;
                },
                onSaved: (value) => sum = double.tryParse(value!) ?? 0.0,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Описание'),
                onSaved: (value) => description = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _updateItem,
                  child:const Text('Сохранить изменения'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}