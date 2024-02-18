import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/models/value_item.dart';

import '../../database/models/Task.dart';
import '../../database/models/User.dart';
import '../../database/models/modelsView/ProjectInfo.dart';
import '../../managers/UserManager.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/CreateTaskView.dart';
import 'MainNavigationControlller.dart';

class CreateTaskViewController extends StatefulWidget {
  late int projectId;
  CreateTaskViewController({super.key, required this.projectId});

  @override
  CreateTaskController createState() {
    return CreateTaskController();
  }
}

class CreateTaskController extends State<CreateTaskViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  late TextEditingController taskNameController;
  late TextEditingController taskDescriptionController;
  ProjectInfo? project;
  late ValueItem selectedProject;
  List<ProjectInfo> projects = [];
  User? user;

  //endregion

  // region Init
  @override
  void dispose() {
    isLoading.dispose();
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    taskNameController = TextEditingController();
    taskDescriptionController = TextEditingController();
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreateTaskView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;
    await ProjectManager().setCurrentProject(widget.projectId);
    user = await UserManager().getCurrentUser();
    project = await ProjectManager().getCurrentProject();
    var p = await ProjectRepository().getAll();
    projects = await ProjectManager().convertListProjectToListProjectInfo(p);






    selectedProject = ValueItem(label: project!.name, value: project?.id!);

    isLoading.value = false;
  }

  List<ValueItem<int>> getOptions(List<ProjectInfo> data) {
    List<ValueItem<int>> items = [];
    for (var project in data) {
      items.add(ValueItem(label: '${project.name}', value: project.id));
    }
    return items;
  }

  //endregion
  //region User Actions

  void onSubmitted() {
    print('submitted');
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      _createTask();
      isLoading.value = false;
    } else {
      print('form is not valid');
    }
  }

  void _createTask() async {
    var date = DateTime.now().toString();
    Task task = Task(
      name: taskNameController.text,
      description: taskDescriptionController.text,
      project: selectedProject.value,
      status: '',
      creator: user!.id!,
      localId: null,
      id: null,
      creationDate: date,
      lastUpdate: date,
    );

    var taskToSend = await WebServiceManager().addTask(task);
    print('task : ${taskToSend.toJson()}');
    navigateBack();
  }
  //endregion

  //region Navigation
  navigateBack() {
    Navigator.pop(context, true);
  }
//endregion

//endregion
}
