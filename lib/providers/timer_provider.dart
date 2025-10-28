import 'dart:async';

import 'package:flutter/material.dart';

import '../models/project.dart';

enum TimerState { idle, running, paused }

class TimerProvider extends ChangeNotifier {
  final Project project;

  late Duration _remainingTime;
  TimerState _timerState = TimerState.idle;
  Timer? _timer;

  TimerProvider({required this.project}) {
    _remainingTime = project.estimatedTime - project.elapsedTime;
  }

  // Getters
  Duration get remainingTime => _remainingTime;
  TimerState get timerState => _timerState;

  double get progress {
    final elapsedTime = project.estimatedTime - _remainingTime;
    return elapsedTime.inSeconds / project.estimatedTime.inSeconds;
  }

  bool get isIdle => _timerState == TimerState.idle;
  bool get isRunning => _timerState == TimerState.running;
  bool get isPaused => _timerState == TimerState.paused;

  // Métodos de control
  void startTimer() {
    _timerState = TimerState.running;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        _remainingTime -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        stopTimer();
      }
    });
  }

  void pauseTimer() {
    _timerState = TimerState.paused;
    _timer?.cancel();
    notifyListeners();
  }

  void resumeTimer() {
    startTimer();
  }

  void stopTimer() {
    _timerState = TimerState.idle;
    _timer?.cancel();
    notifyListeners();
  }

  void addTime(Duration additionalTime) {
    _remainingTime += additionalTime;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
