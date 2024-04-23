import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPageScreen extends StatefulWidget {
  final Map? todo;
  const AddPageScreen({
    super.key,
    this.todo,
  });

  @override
  State<AddPageScreen> createState() => _AddPageScreenState();
}

class _AddPageScreenState extends State<AddPageScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleEditingController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: descriptionEditingController,
                decoration: const InputDecoration(labelText: "Description"),
                minLines: 5,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  onPressed: submitData,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      isEdit ? "Update" : "Submit",
                      style: const TextStyle(fontSize: 20),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitData() async {
    //get the data from form
    final title = titleEditingController.text;
    final description = descriptionEditingController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    //Submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show success or failure message based on the status
    if (response.statusCode == 201) {
      titleEditingController.text = '';
      descriptionEditingController.text = '';

      showSuccessMessage("Todo Created Successfully");
    } else {
      showFailureMessage("Todo Creation Failed");
      print("Creation Failed");
      print(response.statusCode);
      print(response.body);
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
