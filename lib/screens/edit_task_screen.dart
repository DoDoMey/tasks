import 'package:flutter/material.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/providers/tasks_provider.dart';
import 'package:provider/provider.dart';



class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, this.task});
  final Task? task; 

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
 
    if (widget.task != null) {
      titleCtrl.text = widget.task!.title;
      contentCtrl.text = widget.task!.content;
    }
  }

  
  void saveTask() {

  final provider = Provider.of<TasksProvider>(context, listen: false);

    if (widget.task == null) {
 
      provider.addTask(titleCtrl.text, contentCtrl.text);
    } else {
    
      provider.updateTask(widget.task!.id, titleCtrl.text, contentCtrl.text);
    }


    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final taskId = widget.task?.id ?? UniqueKey().toString();

    return Scaffold(
      appBar: AppBar(
   
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          
            Hero(
              tag: 'task_$taskId',
           
              child: Material(
                color: Colors
                    .transparent, 
                child: TextField(
                  controller: titleCtrl, 
                  decoration: InputDecoration(
                    labelText: 'Title',
                    filled: true,

                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),

            Hero(
              tag: 'task_${widget.task?.id ?? UniqueKey().toString()}',
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: contentCtrl,
                  decoration: InputDecoration(labelText: 'Content'),
                  maxLines: 10, 
                  minLines: 5, 
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),

            
            ElevatedButton(onPressed: saveTask, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
