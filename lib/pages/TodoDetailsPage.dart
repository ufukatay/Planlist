import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat
import 'package:file_picker/file_picker.dart';
import 'package:ufukatay_todo/models/TodoModel.dart';
import 'package:ufukatay_todo/controllers/TodoController.dart';

class TodoDetailsPage extends StatefulWidget {
  final String title;
  final String note;
  final TodoItem? item; // Optional parameter for editing

  TodoDetailsPage({required this.title, required this.note, this.item});

  @override
  _TodoDetailsPageState createState() => _TodoDetailsPageState();
}

class _TodoDetailsPageState extends State<TodoDetailsPage> {
  final TodoController _todoController = Get.find();
  Priority _selectedPriority = Priority.low;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _attachmentUrl;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _selectedPriority = widget.item!.priority;
      _selectedDate = widget.item!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.item!.dueDate);
      _attachmentUrl = widget.item!.attachmentUrl;
    }
  }

  void _addOrUpdateTodoItem() {
    final dueDate = DateTime(
      _selectedDate?.year ?? DateTime.now().year,
      _selectedDate?.month ?? DateTime.now().month,
      _selectedDate?.day ?? DateTime.now().day,
      _selectedTime?.hour ?? 0,
      _selectedTime?.minute ?? 0,
    );

    final newItem = TodoItem(
      id: widget.item?.id ?? '', // Use existing id if updating
      title: widget.title,
      note: widget.note,
      priority: _selectedPriority,
      dueDate: dueDate,
      category: Category.work, // Default category, update as needed
      tags: [], // Add tag selection if needed
      attachmentUrl: _attachmentUrl,
    );

    if (widget.item == null) {
      _todoController.addTodoItem(newItem);
    } else {
      _todoController.updateTodoItem(newItem);
    }
    Get.back();
    Get.back();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _attachmentUrl = result.files.single.path;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          TextButton(
            onPressed: _addOrUpdateTodoItem,
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Date'),
            subtitle: Text(_selectedDate == null ? 'Today' : DateFormat('dd MMM yyyy').format(_selectedDate!)),
            value: _selectedDate != null,
            onChanged: (value) async {
              if (value) {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              } else {
                setState(() {
                  _selectedDate = null;
                });
              }
            },
          ),
          SwitchListTile(
            title: const Text('Time'),
            subtitle: Text(_selectedTime == null ? 'None' : _selectedTime!.format(context)),
            value: _selectedTime != null,
            onChanged: (value) async {
              if (value) {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              } else {
                setState(() {
                  _selectedTime = null;
                });
              }
            },
          ),
          ListTile(
            title: const Text('Priority'),
            subtitle: Text(_selectedPriority.toString().split('.').last),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Priority? picked = await showDialog<Priority>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Select Priority'),
                    children: Priority.values.map((priority) {
                      return SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, priority);
                        },
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  _selectedPriority = picked;
                });
              }
            },
          ),
          ListTile(
            title: const Text('Attach a file'),
            subtitle: Text(_attachmentUrl == null ? 'None' : 'Attachment added'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _pickFile,
          ),
        ],
      ),
    );
  }
}
