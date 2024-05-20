import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ufukatay_todo/models/TodoModel.dart';
import 'package:ufukatay_todo/pages/TodoDetailsPage.dart';

class AddTodoPage extends StatefulWidget {
  final TodoItem? item;

  AddTodoPage({this.item});

  @override
  _AddTodoPageState createState() =>_AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _noteController.text = widget.item!.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Reminder',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
                Get.to(TodoDetailsPage(
                  title: _titleController.text.trim(),
                  note: _noteController.text.trim(),
                  item: widget.item,
                ));
              } else {
                Get.snackbar("Error", "Please fill in all fields", snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.blue, fontSize: 10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Notes',
                border: InputBorder.none,
              ),
            ),
            const Spacer(),
            ListTile(
              tileColor: Colors.grey.shade300,
              title: const Text('Details', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Today', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
                  Get.to(TodoDetailsPage(
                    title: _titleController.text.trim(),
                    note: _noteController.text.trim(),
                    item: widget.item, // Pass item to TodoDetailsPage
                  ));
                } else {
                  Get.snackbar("Error", "Please fill in all fields", snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
