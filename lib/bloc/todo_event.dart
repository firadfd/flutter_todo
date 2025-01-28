import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;

  AddTodo(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleTodoStatus extends TodoEvent {
  final int index;

  ToggleTodoStatus(this.index);

  @override
  List<Object?> get props => [index];
}

class DeleteTodoAt extends TodoEvent {
  final int index;

  DeleteTodoAt(this.index);

  @override
  List<Object?> get props => [index];
}

