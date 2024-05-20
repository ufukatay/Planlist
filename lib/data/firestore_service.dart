import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufukatay_todo/models/TodoModel.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  Future<void> addTodoItem(TodoItem item) async {
    await _db.collection('users').doc(_userId).collection('todos').add(item.toMap());
  }

  Future<void> updateTodoItem(TodoItem item) async {
    await _db.collection('users').doc(_userId).collection('todos').doc(item.id).update(item.toMap());
  }

  Future<void> deleteTodoItem(String id) async {
    await _db.collection('users').doc(_userId).collection('todos').doc(id).delete();
  }

  Stream<List<TodoItem>> getTodoItems() {
    return _db.collection('users').doc(_userId).collection('todos').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => TodoItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }
}
