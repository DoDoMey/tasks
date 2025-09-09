import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks/providers/tasks_provider.dart';
import 'package:tasks/screens/edit_task_screen.dart';
import 'package:tasks/screens/login_screen.dart';
import 'package:tasks/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
 
    _initialLoad = Provider.of<TasksProvider>(
      context,
      listen: false,
    ).fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
     
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), 
            onPressed: () {
             
              FirebaseAuth.instance.signOut();
             
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),

      body: FutureBuilder(
     
        future: _initialLoad, 
        builder: (ctx, snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting) {
           
            return Center(child: CircularProgressIndicator());
          }

          return Consumer<TasksProvider>(
            builder: (ctx, tasksProvider, _) => RefreshIndicator(
              onRefresh: () => tasksProvider.fetchTasks(),
              child: tasksProvider.tasks.isEmpty
                  ? Center(child: Text('No tasks yet.'))
                  : ListView.builder(
                      itemCount: tasksProvider.tasks.length,
                      itemBuilder: (_, i) =>
                          TaskTile(task: tasksProvider.tasks[i]),
                    ),
            ),
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditTaskScreen()),
          
        ),
        child: Icon(Icons.add), 
      ),
    );
  }
}
