import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority { low, medium, high }
enum Category { work, personal, shopping }
enum Tag { urgent, later, important }

class TodoItem {
  String id;
  String title;
  String note;
  Priority priority;
  DateTime dueDate;
  Category category;
  List<Tag> tags;
  String? attachmentUrl;
  bool completed;

  TodoItem({
    this.id = '',
    required this.title,
    required this.note,
    required this.priority,
    required this.dueDate,
    required this.category,
    required this.tags,
    this.attachmentUrl,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'priority': priority.toString().split('.').last,
      'dueDate': Timestamp.fromDate(dueDate),
      'category': category.toString().split('.').last,
      'tags': tags.map((tag) => tag.toString().split('.').last).toList(),
      'attachmentUrl': attachmentUrl,
      'completed': completed,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map, String id) {
    return TodoItem(
      id: id,
      title: map['title'],
      note: map['note'],
      priority: Priority.values.firstWhere((e) => e.toString().split('.').last == map['priority']),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      category: Category.values.firstWhere((e) => e.toString().split('.').last == map['category']),
      tags: (map['tags'] as List).map((tag) => Tag.values.firstWhere((e) => e.toString().split('.').last == tag)).toList(),
      attachmentUrl: map['attachmentUrl'],
      completed: map['completed'] ?? false,
    );
  }
}
