import 'package:flutter/material.dart';
import 'package:todo_crud/screens/add_page_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ToDo List"),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: navigateToAdd, label: const Text("Add Todo")));
  }

  void navigateToAdd() {
    final route =
        MaterialPageRoute(builder: (context) => const AddPageScreen());
    Navigator.push(context, route);
  }
}
