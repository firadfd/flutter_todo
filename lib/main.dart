import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/screen/todo_screen.dart';

import 'bloc/todo_bloc.dart';
import 'cubit/todo_cubut.dart';
import 'model/todo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(Hive.box<Todo>('todos')),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: TodoScreen()),
      ),
    );
  }
}
