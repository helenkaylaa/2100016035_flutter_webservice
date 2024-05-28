import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/to_do.dart';
import 'form.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late Future<List<ToDo>> _toDoList;

  @override
  void initState() {
    super.initState();
    _toDoList = fetchToDo();
  }

  Future<List<ToDo>> fetchToDo() async {
    var url = Uri.parse(
        'https://jsonplaceholder.typicode.com/todos?_start=0&_limit=10');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      return data.map((json) => ToDo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load to-do list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
      ),
      drawer: buildDrawer(context),
      body: FutureBuilder<List<ToDo>>(
        future: _toDoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada to do list :('));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ListTile(
                    title: Text(snapshot.data![index].title),
                    subtitle:
                        Text('Completed: ${snapshot.data![index].completed}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Form'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyFormPage()),
              );
            },
          ),
          ListTile(
            title: const Text('To Do'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ToDoPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
