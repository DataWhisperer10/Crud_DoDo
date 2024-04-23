import 'package:flutter/material.dart';
import 'package:todo_crud/api_services/todo_services.dart';
import 'package:todo_crud/screens/add_page_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List items = [];
  Map<String, dynamic>? selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("ToDo List")),
      ),
      body: Stack(children: [
        SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset("assets/bgImage.jpg")),
        Visibility(
          visible: isLoading,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: Center(
                child: Text(
                  "Click On Add Todo ",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            navigateToEdit(item);
                            //open the edit screen
                          } else if (value == 'delete') {
                            //open the delete screen
                            deleteById(id);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              child: Text("Edit"),
                              value: 'edit',
                            ),
                            const PopupMenuItem(
                              child: Text("Delete"),
                              value: 'delete',
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAdd,
        label: const Text("Add Todo"),
      ),
    );
  }

  Future<void> navigateToEdit(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddPageScreen(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAdd() async {
    final route =
        MaterialPageRoute(builder: (context) => const AddPageScreen());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoServices.deletById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      return showFailureMessage("Deletion Failed");
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoServices.fetchTodos();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showFailureMessage("Something Went Wrong");
    }
    setState(() {
      isLoading = false;
    });
  }

  void showFailureMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
