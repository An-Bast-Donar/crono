import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Calcular el progreso (0.0 a 1.0)
    final progress =
        project.estimatedTime.inSeconds > 0
            ? (project.elapsedTime.inSeconds / project.estimatedTime.inSeconds)
                .clamp(0.0, 1.0)
            : 0.0;

    // Formatear el tiempo en minutos
    final elapsedMinutes = project.elapsedTime.inMinutes;
    final estimatedMinutes = project.estimatedTime.inMinutes;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del proyecto
              Text(
                project.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Barra de progreso
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progreso',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '$elapsedMinutes / $estimatedMinutes min',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Barra de progreso personalizada
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.5),
                      child: Row(
                        children: [
                          // Parte completada
                          if (progress > 0)
                            Expanded(
                              flex: (progress * 100).round(),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors:
                                        progress >= 1.0
                                            ? [
                                              Colors.red.shade400,
                                              Colors.red.shade600,
                                            ]
                                            : [
                                              colorScheme.primary,
                                              colorScheme.primary.withValues(
                                                alpha: 0.7,
                                              ),
                                            ],
                                  ),
                                ),
                              ),
                            ),
                          // Parte restante
                          if (progress < 1.0)
                            Expanded(
                              flex: ((1.0 - progress) * 100).round(),
                              child: Container(
                                color: colorScheme.surfaceContainerHighest,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Porcentaje
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
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
