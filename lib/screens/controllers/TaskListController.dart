import 'dart:async';
import 'dart:convert';
import 'package:collaboratask/database/models/Task.dart';
import 'package:collaboratask/database/models/User.dart';
import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/database/repository/UserRepository.dart';
import 'package:collaboratask/managers/TaskManager.dart';
import 'package:collaboratask/managers/UserManager.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/ressources/enum/EnumFilter.dart';
import 'package:collaboratask/ressources/enum/EnumStatus.dart';
import 'package:collaboratask/screens/controllers/CreateTaskController.dart';
import 'package:collaboratask/screens/controllers/TaskController.dart';
import 'package:collaboratask/theme/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import '../../database/models/Project.dart';
import '../../database/models/UserInfo.dart';
import '../../database/repository/TaskRepository.dart';
import '../../database/repository/UserInfoRepository.dart';
import '../../main.dart';
import '../../utils/navigation_utils.dart';
import '../views/TaskListView.dart';

class TaskListViewController extends StatefulWidget {
  const TaskListViewController({super.key});

  @override
  TaskListController createState() {
    return TaskListController();
  }
}

class TaskListController extends State<TaskListViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  List<Task> taskFiltered = [];
  List<Task> tasks = [];
  List<Color> colors = [
    CustomColors.PRIMARY.withOpacity(0.7),
    CustomColors.SECONDARY.withOpacity(0.7),
    CustomColors.TERTIARY.withOpacity(0.7),
    CustomColors.QUATERNARY.withOpacity(0.7),
  ];
  List<String> cardNames = EnumStatus.values.map((e) => e.name).toList();

  Project? projectRandom;
  EnumFilter? selectedStatus;
  late EnumStatus currentStatus;
  final MultiSelectController controllerSelect = MultiSelectController();



  TextEditingController searchBarController = TextEditingController();
  ValueNotifier<bool> searchBarIsEmpty = ValueNotifier(true);
  Timer? _timerSearch;

  //endregion

  // region Init
  @override
  void dispose() {
    isLoading.dispose();
    searchBarController.dispose();
    _timerSearch?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TaskListView(this);
  }

  //endregion

  //region Data
  Future<void> _loadData() async {
    isLoading.value = true;
    tasks = await TaskRepository().getAll();
    taskFiltered = tasks;
    projectRandom = await ProjectRepository().getByServerId(tasks.where((element) => element.project != null).first.project);
print(" ${tasks.map((e) => e.status).toList()}");
    selectedStatus = EnumFilter.ALL;

    isLoading.value = false;
  }

  //endregion
  Future<UserInfo?> getTaskCreator(int id) async {
    UserInfo? user = await UserInfoRepository().getByServerId(id);
    return user;
  }
  List<DropdownMenuItem<String>> getStatusOptions(List<EnumStatus> data){
    return data.map((menu) {
      return DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(menu.name),
        ),
        value: menu.getValue(),
      );
    }).toList();
  }

  filterTaskByStatus(EnumFilter onChanged) {
    print("filterTaskByStatus ${onChanged.getValue()}");
    if(onChanged == EnumFilter.ALL){
      setState(() {
        taskFiltered = tasks;
      });
      return;
    }

    setState(() {
      selectedStatus = onChanged;
      taskFiltered = tasks.where((element) => element.status.toUpperCase().contains(
          onChanged.getValue().toUpperCase())).toList();

    });
  }


  onFilterRemove() {
    print("onFilterRemove");
    //controllerSelect.clearAllSelection();
      taskFiltered = tasks;
  }

  getCountTaskByStatus(EnumStatus status) {

    return tasks.where((element) => EnumStatus.getStatusFromString(element.status) == status).length;
  }

  //region User action
  didPressOnAddBarButton() async {
    _navigateToTaskForm();
  }

  Future<void> didPullToRefresh() async {
    isLoading.value = true;
  }

  onTapTask(int TaskId) async {
    await TaskManager().setCurrentTask(TaskId);
    _navigateToTask(TaskId);
  }

  didTapOnTask(int TaskId) async {
    await TaskManager().setCurrentTask(TaskId);
    _navigateToTask(TaskId);
  }

  didPressOnClearBarButton() {
    searchBarController.clear();

    setState(() {
      taskFiltered = tasks;
    });

    searchBarIsEmpty.value = true;
  }

  didSearchText(String searchText) {
    if (searchText.isNotEmpty) {
      searchBarIsEmpty.value = false;
    } else {
      taskFiltered = tasks;
      searchBarIsEmpty.value = true;
    }

    // on attends 300ms que l'utilisateur ait fini de taper
    if (_timerSearch?.isActive ?? false) _timerSearch?.cancel();
    _timerSearch = Timer(const Duration(milliseconds: 300), () async {
      isLoading.value = true;

      getTaskByTitleOrDescription(searchText.toLowerCase());

      isLoading.value = false;
    });
  }

  getTaskByTitleOrDescription(String searchText) {
    List<Task> TaskFound = [];
    List<Task> TasksByTitle = tasks.where((element) => element.name.toLowerCase().contains(searchText) || element.description.toLowerCase().contains(searchText)).toList();

    TaskFound.addAll(TasksByTitle);

    taskFiltered = TaskFound;
  }

  //endregion

  //region Navigation
  void _navigateToTaskForm() {
    NavigationUtils().navigateTo(context, CreateTaskViewController(projectId: projectRandom!.id!));
  }

  void _navigateToTask(int TaskId) async {
    await NavigationUtils()
        .navigateTo(
            context,
            TaskViewController(
              taskId: TaskId,
            ))
        .then((value) {
      setState(() {
        _loadData();
      });
    });
  }
//endregion
}
