import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_to_do/models/todo.dart';
import 'package:what_to_do/services/todo_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [];

  final _formKey = GlobalKey<FormState>();

  final TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getAll();
  }

  getAll() {
    _todoService.getAllTodo().then((todos) {
      setState(() {
        this.todos = todos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('What To Do'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        await _todoService.deleteTodo(todo.id!);
                        setState(() {
                          todos.removeAt(index);
                        });
                      },
                      child: ListTile(
                        leading: Text("${index + 1}"),
                        title: Text(todo.name),
                        trailing: CupertinoSwitch(
                          value: todo.isComplete,
                          onChanged: (value) async {
                            todo.isComplete = value;
                            await _todoService.updateTodo(todo);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        onSaved: (value) async {
                          await _todoService.createTodo(value!);
                          getAll();
                        },
                        decoration: InputDecoration(
                            label: Text("What's on your mind?")),
                      ),
                    ),
                    ElevatedButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          _formKey.currentState!.save();
                          _formKey.currentState!.reset();
                          setState(() {});
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
