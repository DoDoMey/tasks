
class Task {
  final String id;
  final String title;
  final String content;
  final bool done;
  

  Task({required this.id, required this.title, required this.content, this.done = false});

  Map<String, dynamic> toMap() => {
    'title': title,
    'content': content,
    'done': done,
  };

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'],
      content: data['content'],
      done: data['done'] ?? false,
    
    );
  }
}
