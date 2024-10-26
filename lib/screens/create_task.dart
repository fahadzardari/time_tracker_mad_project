import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/db/db.services.dart';
import 'package:time_tracker_mad_project/db/models/Task.dart';
import 'package:uuid/uuid.dart'; // Make sure to import the correct uuid package

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
        title: const Text('Create Task'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              // Title field with validation
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description field with validation
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tag field with validation
              TextFormField(
                controller: tagController,
                decoration: const InputDecoration(
                  labelText: 'Tag',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown for priority selection
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Priority'),
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

              // Create Task button
              ElevatedButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    // Save task to database
                    await _dbHelper.insertTask({
                      'id': Uuid()
                          .v4(), // Use the correct method to generate UUID
                      'title': titleController.text,
                      'description': descController.text,
                      'createdAt': DateTime.now().toIso8601String(),
                      'isComplete': false,
                      'totalTime': 0,
                      'priority': priority,
                      'tag': tagController.text // Save the tag from controller
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Succesfully Added Task")));

                    Navigator.pushNamed(context, "/");
                  }
                },
                child: const Text('Create Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
