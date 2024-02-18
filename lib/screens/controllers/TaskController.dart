import 'package:collaboratask/database/models/UserInfo.dart';
import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/screens/controllers/EditTaskController.dart';
import 'package:flutter/material.dart';

import '../../database/models/Task.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/TaskView.dart';
import 'MainNavigationControlller.dart';

class TaskViewController extends StatefulWidget {
  TaskViewController({super.key, required this.taskId});
  late int taskId;

  @override
  TaskController createState() {
    return TaskController();
  }
}

class TaskController extends State<TaskViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  Task? task;
  UserInfo? creator;

  //endregion

  // region Init
  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TaskView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;
    task = await TaskRepository().getByServerId(widget.taskId);
    creator = await UserInfoRepository().getByServerId(task!.creator);

    isLoading.value = false;
  }

  //endregion
  didTapOnEdit() {
    navigateToEditTask(task!.id!);
  }

  //region Navigation
  void navigateToEditTask(int taskId)async {
    await NavigationUtils().navigateTo(
        context,
        EditTaskViewController(
          TaskId: taskId,
        )).then((value) {
          setState(() {
            _loadData();
          });
    });
  }

  navigateBack() async{
    Navigator.pop(context, true);
  }
//endregion

//endregion
}
