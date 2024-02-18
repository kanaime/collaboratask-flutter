import 'dart:async';
import 'dart:convert';
import 'package:collaboratask/database/models/Project.dart';
import 'package:collaboratask/database/models/User.dart';
import 'package:collaboratask/database/models/modelsView/ProjectInfo.dart';
import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/database/repository/ProjectUserRepository.dart';
import 'package:collaboratask/database/repository/UserRepository.dart';
import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/managers/UserManager.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/screens/controllers/CreateProjectController.dart';
import 'package:collaboratask/screens/controllers/ProjectController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database/models/UserInfo.dart';
import '../../database/repository/TaskRepository.dart';
import '../../database/repository/UserInfoRepository.dart';
import '../../main.dart';
import '../../utils/navigation_utils.dart';
import '../views/ProjectListView.dart';

class ProjectListViewController extends StatefulWidget {
  const ProjectListViewController({super.key});

  @override
  ProjectListController createState() {
    return ProjectListController();
  }
}

class ProjectListController extends State<ProjectListViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  List<ProjectInfo> projectFiltered = [];
  List<Project> projects = [];
  List<ProjectInfo> projectInfos = [];

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
    return ProjectListView(this);
  }

  //endregion

  //region Data
  Future<void> _loadData() async {
    isLoading.value = true;
    projects = await ProjectRepository().getAll();
    projectInfos = await ProjectManager().convertListProjectToListProjectInfo(projects);
    projectFiltered = projectInfos;


    isLoading.value = false;
  }

  Future<int> getCountTaskByProject(int projectId) async {
    int count = await TaskRepository().getCountTaskByProject(projectId);
    print("count $count");
    return count;
  }

  Future<List<UserInfo>> getUsersForProject(int projectId) async {
    List<UserInfo> users = [];

    var project = await ProjectRepository().getByServerId(projectId);
    if (project != null) {
      List<UserInfo> usersFromDb = await UserInfoRepository().getUserInfosInProject(projectId);
      if (usersFromDb.isNotEmpty) {
        users.addAll(usersFromDb);
      }
    }
    return users;
  }

  Future<double>? getPercentage(projectId) {
    return TaskRepository().getPercetageTaskDoneByProject(projectId);
  }


  //endregion



  //region User action
  didPressOnAddBarButton()async {
    _navigateToProjectForm();
  }

  Future<void> didPullToRefresh() async {
    isLoading.value = true;
  }



  onTapProject(int projectId) async {
    await ProjectManager().setCurrentProject(projectId);
    _navigateToProject(projectId);
  }

  didPressOnClearBarButton() {
    searchBarController.clear();

    setState(() {
      projectFiltered = projectInfos;
    });

    searchBarIsEmpty.value = true;
  }

  didSearchText(String searchText) {
    if (searchText.isNotEmpty) {
      searchBarIsEmpty.value = false;
    } else {
      projectFiltered = projectInfos;
      searchBarIsEmpty.value = true;
    }

    // on attends 300ms que l'utilisateur ait fini de taper
    if (_timerSearch?.isActive ?? false) _timerSearch?.cancel();
    _timerSearch = Timer(const Duration(milliseconds: 300), () async {
      isLoading.value = true;

      getProjectByTitleOrDescription(searchText.toLowerCase());

      isLoading.value = false;
    });
  }

  getProjectByTitleOrDescription(String searchText)  {
    List<ProjectInfo> projectFound = [];
   List<ProjectInfo> projectsByTitle = projectInfos.where((element) => element.name.toLowerCase().contains(searchText)|| element.description.toLowerCase().contains(searchText)).toList();

    projectFound.addAll(projectsByTitle);

    projectFiltered = projectFound;
  }

  //endregion

  //region Navigation
  void _navigateToProjectForm() {
    NavigationUtils().navigateTo(context, const CreateProjectViewController());
  }
  void _navigateToProject(int projectId) async {
    await NavigationUtils().navigateTo(context, ProjectViewController(projectId: projectId,)).then((value) {
      setState(() {
        _loadData();
      });
    });
  }
//endregion
}
