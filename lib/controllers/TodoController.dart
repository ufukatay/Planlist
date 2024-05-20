import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ufukatay_todo/models/TodoModel.dart';
import 'package:ufukatay_todo/data/firestore_service.dart';

class TodoController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  var todoItems = <TodoItem>[].obs;
  var isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadTodoItemsFromCache();
    todoItems.bindStream(_firestoreService.getTodoItems());
    ever(todoItems, (_) => cacheTodoItems());
  }

  void loadTodoItemsFromCache() {
    List<dynamic> cachedItems = box.read<List<dynamic>>('todos') ?? [];
    if (cachedItems.isNotEmpty) {
      todoItems.assignAll(cachedItems.map((item) => TodoItem.fromMap(item, item['id'])).toList());
    }
  }

  void cacheTodoItems() {
    box.write('todos', todoItems.map((item) => item.toMap()).toList());
  }

  void addTodoItem(TodoItem item) async {
    isLoading(true);
    await _firestoreService.addTodoItem(item);
    isLoading(false);
  }

  void updateTodoItem(TodoItem item) async {
    isLoading(true);
    await _firestoreService.updateTodoItem(item);
    isLoading(false);
  }

  void deleteTodoItem(String id) async {
    isLoading(true);
    await _firestoreService.deleteTodoItem(id);
    isLoading(false);
  }
}
