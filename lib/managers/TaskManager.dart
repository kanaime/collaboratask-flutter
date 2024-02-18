import 'dart:convert';

import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/managers/UserInfoManager.dart';

import '../database/models/Task.dart';
import 'package:http/http.dart' as http;

import '../ressources/Constant.dart';

class TaskManager {
  static final TaskManager _instance = TaskManager._internal();

  factory TaskManager() {
    return _instance;
  }

  TaskManager._internal();

  static Task? _currentTask;


  final List<Task> _Tasks = [];

  List<Task> get Tasks => _Tasks;

  Future<Task> getCurrentTask() async {
    if (_currentTask != null) {
      return _currentTask!;
    }
    Task? task = await TaskRepository().getByServerId(1);
    _currentTask = task;
    return _currentTask!;
  }

  setCurrentTask(int TaskId) async {
    Task? task = await TaskRepository().getByServerId(TaskId);
    _currentTask = task;
  }

  reset() {
    _currentTask = null;
  }

}
