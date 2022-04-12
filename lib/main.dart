import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_to_do/models/todo.dart';

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

  var _formKey = GlobalKey<FormState>();

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
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        setState(() {
                          todos.removeAt(index);
                        });
                      },
                      child: ListTile(
                        leading: Text("${index + 1}"),
                        title: Text(todos[index].title),
                        trailing: CupertinoSwitch(
                          value: todos[index].completed,
                          onChanged: (value) {
                            setState(() {
                              todos[index].completed = value;
                            });
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
                        onSaved: (value) {
                          todos.add(Todo(title: value!));
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
