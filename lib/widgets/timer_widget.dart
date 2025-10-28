import 'package:crono/models/project.dart';
import 'package:crono/providers/project_provider.dart';
import 'package:crono/providers/timer_provider.dart';
import 'package:crono/widgets/timer_complete_dialog.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Project project;

  const TimerWidget({super.key, required this.project});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late TimerProvider _timerProvider;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _timerProvider = TimerProvider(project: widget.project);
    _timerProvider.addListener(_onTimerStateChanged);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timerProvider.removeListener(_onTimerStateChanged);
    _timerProvider.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onTimerStateChanged() {
    if (_timerProvider.isRunning) {
      if (!_fadeController.isAnimating) {
        _fadeController.repeat(reverse: true);
      }
    } else {
      _fadeController.stop();
      _fadeController.reset();
    }

    if (_timerProvider.remainingTime.inSeconds == 0) {
      _showTimeUpDialog();
    }

    setState(() {});
  }

  void _handleStart() {
    _timerProvider.startTimer();
  }

  void _handlePause() {
    _timerProvider.pauseTimer();
  }

  void _handleResume() {
    _timerProvider.resumeTimer();
  }

  void _handleStop() {
    _timerProvider.stopTimer();
    Navigator.of(context).pop();
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => TimerCompleteDialog(
            projectName: widget.project.name,
            onComplete: _handleCompleteProject,
            onAddTime: _handleAddMoreTime,
          ),
    );
  }

  void _handleCompleteProject() {
    // Aquí puedes agregar lógica adicional si es necesario
    // Por ahora solo regresamos al menú
    Navigator.of(context).pop();
  }

  void _handleAddMoreTime(int additionalMinutes) {
    // Agregar tiempo al temporizador
    final additionalDuration = Duration(minutes: additionalMinutes);
    _timerProvider.addTime(additionalDuration);

    // Actualizar el tiempo estimado del proyecto
    final updatedProject = widget.project.copyWith(
      estimatedTime: widget.project.estimatedTime + additionalDuration,
    );

    ProjectProvider().updateProject(widget.project.id, updatedProject);

    // Reiniciar el temporizador automáticamente
    _timerProvider.startTimer();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor(ColorScheme colorScheme) {
    final remainingProgress =
        _timerProvider.remainingTime.inSeconds /
        widget.project.estimatedTime.inSeconds;

    if (remainingProgress > 0.5) {
      return colorScheme.primary;
    } else if (remainingProgress > 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timerColor = _getTimerColor(colorScheme);
    final progress = _timerProvider.progress;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tiempo en formato grande y minimalista
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              _formatDuration(_timerProvider.remainingTime),
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w100,
                color: timerColor,
                letterSpacing: 8,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Barra de progreso minimalista
          Container(
            width: 400,
            height: 2,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 400 * progress,
                height: 2,
                decoration: BoxDecoration(
                  color: timerColor,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: timerColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),

          // Botones de acción
          _buildActionButtons(colorScheme),

          // Botón de detener (solo visible en estado de pausa)
          if (_timerProvider.isPaused) ...[
            const SizedBox(height: 24),
            _ActionButton(
              onPressed: _handleStop,
              label: 'DETENER Y REGRESAR AL MENÚ',
              color: colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    if (_timerProvider.isIdle) {
      return _ActionButton(
        onPressed: _handleStart,
        label: 'EMPEZAR MODO ENFOQUE',
        color: colorScheme.primary,
      );
    } else if (_timerProvider.isRunning) {
      return _ActionButton(
        onPressed: _handlePause,
        label: 'TOMARME UN BREAK',
        color: Colors.orange,
      );
    } else {
      return _ActionButton(
        onPressed: _handleResume,
        label: 'CONTINUAR CON EL BELLAQUEO',
        color: Colors.green,
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;

  const _ActionButton({
    required this.onPressed,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
