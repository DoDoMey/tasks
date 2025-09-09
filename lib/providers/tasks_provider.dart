import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks/models/task.dart';

class TasksProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final List<Task> _tasks = [];

  List<Task> get tasks => [..._tasks];

  Future<void> fetchTasks() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .get();
    _tasks.clear();
    _tasks.addAll(snap.docs.map((doc) => Task.fromMap(doc.id, doc.data())));
    notifyListeners();
  }

  Future<void> addTask(String title, String content) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add({'title': title, 'content': content});
    _tasks.add(Task(id: docRef.id, title: title, content: content));
    notifyListeners();
  }

  Future<void> updateTask(
    String id,
    String title,
    String content, {
    bool? done,
    String? category,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('users').doc(uid).collection('tasks').doc(id).update({
      'title': title,
      'content': content,
      if (done != null) 'done': done,
      if (category != null) 'category': category,
    });

    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = Task(
        id: id,
        title: title,
        content: content,
        done: done ?? _tasks[index].done,
       
      );
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('users').doc(uid).collection('tasks').doc(id).delete();
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
