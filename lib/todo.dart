
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  Todo(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    this.title = data['title'];
    final Timestamp timestamp = data['createdAt'];
    this.createdAt = timestamp.toDate();
  }

  String title = "";
  DateTime createdAt = DateTime.now();
}