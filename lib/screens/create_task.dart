import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/db/db.services.dart';
import 'package:time_tracker_mad_project/db/models/Task.dart';
import 'package:uuid/uuid.dart';

class CreateTask extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  int priority = 1; // Default priority value
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Task',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: tagController,
                decoration: InputDecoration(
                  labelText: 'Tag',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: priority,
                items: [
                  DropdownMenuItem(child: Text('Low'), value: 1),
                  DropdownMenuItem(child: Text('Medium'), value: 2),
                  DropdownMenuItem(child: Text('High'), value: 3),
                ],
                onChanged: (int? value) {
                  if (value != null) {
                    priority = value;
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a priority.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      // Save task to database
                      await _dbHelper.insertTask({
                        'id': Uuid().v4(),
                        'title': titleController.text,
                        'description': descController.text,
                        'createdAt': DateTime.now().toIso8601String(),
                        'isComplete': false,
                        'totalTime': 0,
                        'priority': priority,
                        'tag': tagController.text
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Successfully Added Task"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pushNamed(context, "/");
                    }
                  },
                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Create Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
