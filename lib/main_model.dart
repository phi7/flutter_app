import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/todo.dart';

class MainModel extends ChangeNotifier{
  List<Todo> todoList = [];

  Future getTodoList() async {
    final snapshot = await FirebaseFirestore.instance.collection('todoList').get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc) => Todo(doc)).toList();
    this.todoList = todoList;
    notifyListeners();
  }

  void getTodoListRealtime(){
    final snapshots = FirebaseFirestore.instance.collection('todoList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final todoList = docs.map((doc) => Todo(doc)).toList();
      todoList.sort((a,b) => b.createdAt.compareTo(a.createdAt));
      this.todoList = todoList;
      notifyListeners();
    });
  }

  void reload(){
    notifyListeners();
  }

  Future deleteCheckedItems() async{
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    final references = checkedItems.map((todo) => todo.documentReference).toList();


    final batch = FirebaseFirestore.instance.batch();

    references.forEach((reference) {
      batch.delete(reference);
    });

    return batch.commit();
  }
}