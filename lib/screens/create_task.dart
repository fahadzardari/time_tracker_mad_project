import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/db/db.services.dart';
import 'package:time_tracker_mad_project/db/models/Task.dart';

class CreateTask extends StatelessWidget {

  final _key = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController tag = TextEditingController();
  late int priority = 1;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: desc,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tag,
                decoration: const InputDecoration(
                  labelText: 'Tag',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                items: [
                DropdownMenuItem(child: Text('Low'), value: 1),
                DropdownMenuItem(child: Text('Medium'), value: 2),
                DropdownMenuItem(child: Text('High'), value: 3),
              ], onChanged: (int? value) {
                priority = value!;
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Task task = Task(
                    id: '',
                    title: title.text,
                    description: desc.text,
                    created_at: DateTime.now(),
                    total_time_spent: '0',
                    status: 'Pending',
                    tag: tag.text,
                    is_favorite: false,
                    priority: priority, 
                  );

                  // save task to database
                  _dbHelper.insertTask(task as Map<String, dynamic>);
                  Navigator.pop(context);
                },
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}