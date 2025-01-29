import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import '../model/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final Box<Todo> _todoBox;

  TodoBloc(this._todoBox) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
    on<DeleteTodoAt>(_onDeleteTodoAt);

    add(LoadTodos()); // Load todos initially
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) {
    try {
      emit(TodoLoading());
      final todos = _todoBox.values.toList();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to load todos'));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    try {
      final todo = Todo(title: event.title);
      _todoBox.add(todo);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError('Failed to add todo'));
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) {
    try {
      final todo = _todoBox.getAt(event.index);
      if (todo != null) {
        _todoBox.putAt(event.index, Todo(title: event.title, isCompleted: todo.isCompleted));
        add(LoadTodos());
      }
    } catch (e) {
      emit(TodoError('Failed to update todo'));
    }
  }

  void _onToggleTodoStatus(ToggleTodoStatus event, Emitter<TodoState> emit) {
    try {
      final todo = _todoBox.getAt(event.index);
      if (todo != null) {
        _todoBox.putAt(event.index,
            Todo(title: todo.title, isCompleted: !todo.isCompleted));
        add(LoadTodos());
      }
    } catch (e) {
      emit(TodoError('Failed to toggle todo status'));
    }
  }

  void _onDeleteTodoAt(DeleteTodoAt event, Emitter<TodoState> emit) {
    try {
      _todoBox.deleteAt(event.index);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError('Failed to delete todo'));
    }
  }
}
