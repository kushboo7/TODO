import 'package:flutter/material.dart';//building user interfaces
import 'package:intl/intl.dart';//to format date and time
import 'dart:math';//built-in dart library

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget //setting app's theme,title
 {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color.fromARGB(255, 208, 229, 243), // Change scaffold background color
      fontFamily: 'Roboto',
      ),
      home: ToDoList(),
    );
  }
}
class ToDoList extends StatefulWidget //represents main screen
 {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  String selectedDateOption = "Today";

  final _motivationalMessages = [
    "You're unstoppable!",
    "One task down, many more victories to go!",
    "Success unlocked! Keep the momentum going.",
    "Small win, big smile!",
    "Task completed, confidence boosted!",
    "You did it! What's next on your list?",
    "One step closer to your dreams.",
    "Task accomplished, dreams in progress.",
    "Mission accomplished, keep conquering!",
"   Success achieved, time for the next challenge!",
    "Bravo! Keep chasing your goals.",
    "You're doing great!",
    "Keep up the good work!",
    "You're on fire!",
    "You're amazing!"
  ];

  void addTask() {
    setState(() {
      String newTask = taskController.text;
      if (newTask.isNotEmpty) {
        DateTime dueDate = calculateDueDate(selectedDateOption);
        tasks.add(Task(title: newTask, dueDate: dueDate));
        taskController.clear();
      }
    });
  }

  DateTime calculateDueDate(String option) {
    DateTime now = DateTime.now();
    if (option == "Today") {
      return now;
    } else if (option == "Tomorrow") {
      return now.add(Duration(days: 1));
    } else {
      return now.add(Duration(days: 7));
    }
  }
  void toggleComplete(int index) {
    setState(() {
      tasks[index].isComplete = !tasks[index].isComplete;
      if (tasks[index].isComplete) {
        _showMotivationalMessage();
      }
    });
  }
  void toggleFavorite(int index) {
    setState(() {
      tasks[index].isFavorite = !tasks[index].isFavorite;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void renameTask(int index, String newName) {
    setState(() {
      tasks[index].title = newName;
    });
  }
  void editTask(int index) async {
  String? newTitle = await showDialog(
    context: context,
    builder: (context) {
      final TextEditingController controller = TextEditingController(text: tasks[index].title);
      return AlertDialog(
        title: Text('Edit Task'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'New Title'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
  if (newTitle != null && newTitle.isNotEmpty) {
    setState(() {
      tasks[index].title = newTitle;
    });
  }
}
  void _showMotivationalMessage() {
    final random = Random();
    final messageIndex = random.nextInt(_motivationalMessages.length);
    final message = _motivationalMessages[messageIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('To-Do List', style: TextStyle(fontWeight: FontWeight.bold)), // Apply bold font weight to title
      centerTitle: true, // Center the title horizontally
      backgroundColor: Colors.blue,),
      backgroundColor: Colors.blue[50],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter task',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                DropdownButton<String>(
                  value: selectedDateOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDateOption = newValue!;
                    });
                  },
                  items: <String>['Today', 'Tomorrow', 'Next Week']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
      onPressed: addTask,
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 2, 137, 248)), 
      ),
      child: Text('Add Task', style: TextStyle(fontSize: 16.0, color: Colors.white)), 
),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(tasks[index].title),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(tasks[index].dueDate)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: tasks[index].isComplete ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                        onPressed: () => toggleComplete(index),
                      ),
                      IconButton(
                        icon: tasks[index].isFavorite ? Icon(Icons.star, color: Colors.yellow) : Icon(Icons.star_border),
                        onPressed: () => toggleFavorite(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editTask(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class Task {
  late String title;
  late DateTime dueDate;
  bool isComplete = false;
  bool isFavorite = false;
  Task({required this.title, required this.dueDate});
}