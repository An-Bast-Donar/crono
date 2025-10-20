import 'package:flutter/material.dart';

import 'new_project_modal.dart';

class NewProjectButton extends StatelessWidget {
  const NewProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const NewProjectModal(),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Nuevo Proyecto'),
    );
  }
}
