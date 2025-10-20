import 'package:crono/widgets/new_project_button.dart';
import 'package:crono/widgets/project_list_view.dart';
import 'package:flutter/material.dart';

class LargeWindowPage extends StatelessWidget {
  const LargeWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        title: const Text('CRONO'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: NewProjectButton(),
          ),
        ],
      ),
      body: const ProjectListView(),
    );
  }
}
