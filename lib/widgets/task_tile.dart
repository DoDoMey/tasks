import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/providers/tasks_provider.dart';
import 'package:tasks/screens/edit_task_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({Key? key, required this.task}) : super(key: key);

  void _toggleDone(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context, listen: false);
    provider.updateTask(
      task.id,
      task.title,
      task.content,
      done: !task.done,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditTaskScreen(task: task),
          ),
        ),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          shadowColor: Colors.blueAccent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => _toggleDone(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: task.done ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: task.done ? Colors.green : Colors.blueAccent,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        task.content,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent, size: 26),
                  onPressed: () {
                    Provider.of<TasksProvider>(
                      context,
                      listen: false,
                    ).deleteTask(task.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
