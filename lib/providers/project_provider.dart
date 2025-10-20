import 'package:crono/models/project.dart';
import 'package:flutter/foundation.dart';

class ProjectProvider extends ChangeNotifier {
  // Singleton
  static final ProjectProvider _instance = ProjectProvider._internal();

  factory ProjectProvider() {
    return _instance;
  }

  ProjectProvider._internal();

  // Lista de proyectos
  final List<Project> _projects = [];

  // Getters
  List<Project> get projects => List.unmodifiable(_projects);

  // Leer/obtener un proyecto por ID
  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  // Agregar un proyecto
  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
    _printProjectsDebug();
  }

  // Actualizar un proyecto
  void updateProject(String id, Project updatedProject) {
    final index = _projects.indexWhere((project) => project.id == id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
      _printProjectsDebug();
    }
  }

  // Eliminar un proyecto por ID
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
    _printProjectsDebug();
  }

  // Imprimir proyectos en modo debug
  void _printProjectsDebug() {
    if (kDebugMode) {
      debugPrint('========== PROYECTOS ==========');
      debugPrint('Total de proyectos: ${_projects.length}');
      if (_projects.isEmpty) {
        debugPrint('No hay proyectos en la lista');
      } else {
        for (var i = 0; i < _projects.length; i++) {
          final project = _projects[i];
          debugPrint(
            '[$i] ID: ${project.id} | Nombre: ${project.name} | '
            'Tiempo estimado: ${project.estimatedTime.inMinutes} minutos | '
            'Tiempo transcurrido: ${project.elapsedTime.inMinutes} minutos',
          );
        }
      }
      debugPrint('================================');
    }
  }
}
