import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/add/add_page.dart';
import 'package:flutter_app/main_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODOアプリ',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getTodoListRealtime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("TODOアプリリリリ"),
          actions: [
            Consumer<MainModel>(builder: (context, model, child) {
                return FlatButton(
                  onPressed: () async{
                    await model.deleteCheckedItems();
                  },
                  child: Text("完了", style: TextStyle(color: Colors.white)),
                );
              }
            )
          ],
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          final todoList = model.todoList;
          return ListView(
            children: todoList
                .map((todo) => CheckboxListTile(
                      title: Text(todo.title),
                      value: todo.isDone,
                      onChanged: (bool? value) {
                        todo.isDone = !todo.isDone;
                        model.reload();
                      },
                      secondary: const Icon(Icons.hourglass_empty),
                    ))
                .toList(),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPage(),
                fullscreenDialog: true,
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
