import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../model/todo_model.dart';

class TodoCubit extends Cubit<List<Todo>> {
  final Box<Todo> _todoBox;

  TodoCubit() : _todoBox = Hive.box<Todo>('todos'), super([]) {
    loadTodos();
  }

  void loadTodos() {
    emit(_todoBox.values.toList());
  }

  void addTodo(String title) {
    final todo = Todo(title: title);
    _todoBox.add(todo);
    loadTodos();
  }

  void toggleTodoStatus(int index) {
    final todo = _todoBox.getAt(index);
    if (todo != null) {
      _todoBox.putAt(index, Todo(title: todo.title, isCompleted: !todo.isCompleted));
      loadTodos();
    }
  }

  void deleteTodoAt(int index) {
    _todoBox.deleteAt(index);
    loadTodos();
  }
}
