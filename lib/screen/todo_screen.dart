import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/bloc/todo_state.dart';
import '../bloc/todo_event.dart';
import '../widgets/ui_helper.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Todo App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              final todos = state.todos;
              if (todos.isEmpty) {
                return const Center(child: Text("No note found"));
              } else {
                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return UiHelper.listItem(todo.title, todo.isCompleted,
                        onCompleted: () {
                      context.read<TodoBloc>().add(ToggleTodoStatus(index));
                    }, onDelete: () {
                      context.read<TodoBloc>().add(DeleteTodoAt(index));
                    }, onUpdate: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController updateTextController = TextEditingController(text: todo.title);
                              return AlertDialog(
                                title: const Text('Update Todo'),
                                content: TextField(
                                  controller: updateTextController,
                                  minLines: 1,
                                  maxLines: null,
                                  textCapitalization: TextCapitalization.sentences,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(hintText: 'Todo Title'),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Update'),
                                    onPressed: () {
                                      if (updateTextController.text.isNotEmpty) {
                                        context.read<TodoBloc>().add(UpdateTodo(index, updateTextController.text));
                                        updateTextController.clear();
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        });
                  },
                );
              }
            } else if (state is TodoError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("Something went wrong"));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Todo'),
                content: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(hintText: 'Todo Title'),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        context.read<TodoBloc>().add(AddTodo(controller.text));
                        controller.clear();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
