import 'package:crono/models/project.dart';
import 'package:crono/widgets/project_title_widget.dart';
import 'package:crono/widgets/timer_widget.dart';
import 'package:flutter/material.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MODO ENFOQUE')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            ProjectTitleWidget(projectName: project.name),
            const SizedBox(height: 32),
            Expanded(child: TimerWidget(project: project)),
          ],
        ),
      ),
    );
  }
}
