import 'package:hive/hive.dart';
part 'todo_model.g.dart'; // Links to the generated code



@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
  });
}
