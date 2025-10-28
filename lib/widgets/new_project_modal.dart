import 'dart:math';

import 'package:crono/models/project.dart';
import 'package:crono/providers/project_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewProjectModal extends StatefulWidget {
  const NewProjectModal({super.key});

  @override
  State<NewProjectModal> createState() => _NewProjectModalState();
}

class _NewProjectModalState extends State<NewProjectModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFormValidity);
    _durationController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkFormValidity);
    _durationController.removeListener(_checkFormValidity);
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final isNameValid = _nameController.text.trim().isNotEmpty;
    final isDurationValid =
        _durationController.text.trim().isNotEmpty &&
        int.tryParse(_durationController.text) != null &&
        int.parse(_durationController.text) > 0;

    setState(() {
      _isFormValid = isNameValid && isDurationValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nuevo Proyecto',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Campo de nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del proyecto',
                  hintText: '',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de tiempo estimado
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Tiempo estimado (minutos)',
                  hintText: '',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed:
                        _isFormValid
                            ? () {
                              if (_formKey.currentState!.validate()) {
                                // Crear el proyecto
                                final projectName = _nameController.text.trim();
                                final durationMinutes = int.parse(
                                  _durationController.text,
                                );

                                // Convertir minutos a segundos explícitamente
                                final estimatedSeconds = durationMinutes * 60;

                                // Generar ID con formato: yyyyMMddHHmmssSSS
                                final now = DateTime.now();
                                final id =
                                    '${now.year}'
                                    '${now.month.toString().padLeft(2, '0')}'
                                    '${now.day.toString().padLeft(2, '0')}'
                                    '${now.hour.toString().padLeft(2, '0')}'
                                    '${now.minute.toString().padLeft(2, '0')}'
                                    '${now.second.toString().padLeft(2, '0')}'
                                    '${now.millisecond.toString().padLeft(4, '0')}';

                                // DEBUG: Generar segundos aleatorios para el progreso
                                int randomElapsedSeconds = 0;
                                if (kDebugMode) {
                                  final random = Random();
                                  randomElapsedSeconds = random.nextInt(
                                    estimatedSeconds + 1,
                                  );
                                }

                                final newProject = Project(
                                  id: id,
                                  name: projectName,
                                  estimatedTime: Duration(
                                    seconds: estimatedSeconds,
                                  ),
                                  elapsedTime: Duration(
                                    seconds: randomElapsedSeconds,
                                  ),
                                );

                                // Agregar el proyecto al provider
                                ProjectProvider().addProject(newProject);

                                // Cerrar la modal
                                Navigator.of(context).pop();
                              }
                            }
                            : null,
                    child: const Text('Crear Proyecto'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
