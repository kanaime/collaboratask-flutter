import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/managers/SyncroManager.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/ressources/enum/EnumStatus.dart';
import 'package:collaboratask/screens/controllers/CreateTaskController.dart';
import 'package:collaboratask/screens/controllers/EditProjectController.dart';
import 'package:collaboratask/screens/controllers/TaskController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/models/value_item.dart';

import '../../database/models/Project.dart';
import '../../database/models/Task.dart';
import '../../database/models/User.dart';
import '../../database/models/UserInfo.dart';
import '../../database/models/modelsView/ProjectInfo.dart';
import '../../database/repository/TaskRepository.dart';
import '../../managers/UserManager.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/ProjectView.dart';
import 'MainNavigationControlller.dart';

class ProjectViewController extends StatefulWidget {
  late int projectId;
  ProjectViewController({super.key, required this.projectId});

  @override
  ProjectController createState() {
    return ProjectController();
  }
}

class ProjectController extends State<ProjectViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ProjectInfo? project;
  List<ValueItem> selectedOptions = [];
  List<Task> tasksProject = [];
  UserInfo? creator;
  User? user;

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
    return ProjectView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;

    var projectDb = await ProjectRepository().getByServerId(widget.projectId);

    project = await ProjectManager().convertProjectToProjectInfo(projectDb!);

    tasksProject = await TaskRepository().getAllByProjectId(project!.id!);
    creator = await UserInfoRepository().getByServerId(project!.creator);
    user = await UserManager().getCurrentUser();

    print("project  ${project?.toJson().toString()}");

    isLoading.value = false;
  }

  List<ValueItem> getOptions(data) {
    List<ValueItem> items = [];
    EnumStatus.values.forEach((element) {
      items.add(ValueItem(label: element.name, value: element.toString()));
    });
    return items;
  }


  Future<double>? getPercentage()  {
    return  TaskRepository().getPercetageTaskDoneByProject(project!.id!);
  }

  Future<UserInfo?> getTaskCreator(int id) async {
    UserInfo? user = await UserInfoRepository().getByServerId(id);
    return user;
  }

  //endregion
  //region User action
  didTapOnEdit() async {
    await NavigationUtils()
        .navigateTo(
            context,
            EditProjectViewController(
              projectId: project!.id!,
            ))
        .then((value) {
      setState(() {
        widget.projectId = value;
        _loadData();
      });
    });
  }

  didTapOnAddTask() {
    navigateToAddTask();
  }
  //endregion

  //region Navigation

  navigateBack() async {
    Navigator.pop(context, true);
  }

  navigateToTask(int taskId) async {
    await NavigationUtils().navigateTo(context, TaskViewController(taskId: taskId)).then((value) {
      setState(() {
        _loadData();
      });
    });
  }

  navigateToAddTask() async {
    await NavigationUtils().navigateTo(context, CreateTaskViewController(projectId: widget.projectId,)).then((value) {
      setState(() {
        _loadData();
      });
    });
  }
//endregion

//endregion
}
