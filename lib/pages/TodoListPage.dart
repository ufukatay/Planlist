import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ufukatay_todo/models/TodoModel.dart';
import 'package:ufukatay_todo/controllers/TodoController.dart';
import 'package:ufukatay_todo/pages/AddTodoPage.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoController _todoController = Get.put(TodoController());
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              )
            : const Text('Plantist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_todoController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_todoController.todoItems.isEmpty) {
                return const Center(child: Text('No to-do items'));
              }

              var filteredItems = _todoController.todoItems.where((item) {
                return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    item.note.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();

              var todayItems = filteredItems.where((item) {
                return item.dueDate.isSameDate(DateTime.now());
              }).toList();
              var tomorrowItems = filteredItems.where((item) {
                return item.dueDate.isSameDate(DateTime.now().add(Duration(days: 1)));
              }).toList();
              var upcomingItems = filteredItems.where((item) {
                var today = DateTime.now();
                var tomorrow = today.add(Duration(days: 1));
                return item.dueDate.isAfter(tomorrow);
              }).toList()
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

              return ListView(
                children: [
                  if (todayItems.isNotEmpty) _buildSection(context, "Today", todayItems),
                  if (tomorrowItems.isNotEmpty) _buildSection(context, "Tomorrow", tomorrowItems),
                  if (upcomingItems.isNotEmpty) _buildSection(context, "Upcoming", upcomingItems),
                ],
              );
            }),
          ),
          _buildNewReminderButton(context),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<TodoItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) => _buildTodoItem(context, item)).toList(),
      ],
    );
  }

  Widget _buildTodoItem(BuildContext context, TodoItem item) {
    return Slidable(
      key: Key(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _editTodoItem(item),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => _todoController.deleteTodoItem(item.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          Icons.circle,
          color: _getPriorityColor(item.priority),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.completed ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.note),
            const SizedBox(height: 4),
            if (item.attachmentUrl != null)
              Row(
                children: [
                  Icon(Icons.attachment, size: 16),
                  Text('Attachment added'),
                ],
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(DateFormat('dd.MM.yyyy').format(item.dueDate)),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(DateFormat('HH:mm').format(item.dueDate)),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: item.completed,
          onChanged: (bool? value) {
            item.completed = value ?? false;
            _todoController.updateTodoItem(item);
          },
        ),
      ),
    );
  }

  void _editTodoItem(TodoItem item) {
    Get.to(AddTodoPage(item: item));
  }

  Widget _buildNewReminderButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 4, 27, 61), // Dark blue color
          padding: const EdgeInsets.symmetric(vertical: 26.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          Get.to(AddTodoPage());
        },
        child: const Text(
          '+ New Reminder',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.blue;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
