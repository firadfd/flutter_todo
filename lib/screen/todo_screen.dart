import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../cubit/todo_cubut.dart';
import '../model/todo_model.dart';

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
        child: BlocBuilder<TodoCubit, List<Todo>>(
          builder: (context, todos) {
            if (todos.isEmpty) {
              return const Center(
                child: Text("No note found"),
              );
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
                    context.read<TodoCubit>().toggleTodoStatus(index);
                  }, onDelete: () {
                    context.read<TodoCubit>().deleteTodoAt(index);
                  });
                },
              );
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
                        context.read<TodoCubit>().addTodo(controller.text);
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

class UiHelper {
  static Widget listItem(
    String title,
    bool isCompleted, {
    required VoidCallback onCompleted,
    required VoidCallback onDelete,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isCompleted ? Colors.green.shade100 : Colors.red.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: isCompleted
                        ? Colors.green.shade800
                        : Colors.grey.shade600,
                  ),
                  onPressed: onCompleted,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: isCompleted
                        ? Colors.green.shade800
                        : Colors.grey.shade600,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
