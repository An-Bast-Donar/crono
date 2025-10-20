import 'package:flutter/material.dart';

import '../providers/project_provider.dart';
import 'project_card.dart';

class ProjectListView extends StatelessWidget {
  const ProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = ProjectProvider();

    return ListenableBuilder(
      listenable: projectProvider,
      builder: (context, child) {
        final projects = projectProvider.projects;

        if (projects.isEmpty) {
          return const Center(
            child: Text(
              'No tienes proyectos creados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ProjectCard(
              project: project,
              onTap: () {
                // Aquí puedes agregar la navegación o acción al hacer clic
                debugPrint('Tap en proyecto: ${project.name}');
              },
            );
          },
        );
      },
    );
  }
}
