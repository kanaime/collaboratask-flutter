import 'package:collaboratask/database/models/UserInfo.dart';
import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/managers/UserManager.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/ressources/enum/EnumStatus.dart';
import 'package:collaboratask/screens/controllers/ProjectController.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../database/models/Project.dart';
import '../../database/models/ProjectUser.dart';
import '../../database/models/User.dart';
import '../../database/models/modelsView/ProjectInfo.dart';
import '../../database/repository/ProjectUserRepository.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../../utils/view_utils.dart';
import '../views/CreateProjectView.dart';
import 'MainNavigationControlller.dart';

class CreateProjectViewController extends StatefulWidget {
  const CreateProjectViewController({super.key});

  @override
  CreateProjectController createState() {
    return CreateProjectController();
  }
}

class CreateProjectController extends State<CreateProjectViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  late TextEditingController projectNameController;
  late TextEditingController projectDescriptionController;
  late TextEditingController projectStatusController;
  List<UserInfo> usersInfo = [];
  List<ValueItem<int>> selectedUsers = [];

  //endregion

  // region Init
  @override
  void dispose() {
    projectNameController.dispose();
    projectDescriptionController.dispose();
    projectStatusController.dispose();
    isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    projectNameController = TextEditingController();
    projectDescriptionController = TextEditingController();
    projectStatusController = TextEditingController();
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreateProjectView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;

    usersInfo = await UserInfoRepository().getAll();

    isLoading.value = false;
  }

  List<ValueItem<int>> getOptions(List<UserInfo> data) {
    List<ValueItem<int>> items = [];
    for (var user in data) {
      items.add(ValueItem(label: '${user.firstName}', value: user.id));
    }
    return items;
  }

  onSubmitted() {
    print('submitted');
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      _createProject();
      print("selected users ${selectedUsers}");

      isLoading.value = false;
    } else {
      print('error');
    }
  }

  _createProject() async {
    User? creator = await UserManager().getCurrentUser();
    var now = DateTime.now().toString();

    List<int>? usersValue = [];
    for (var user in selectedUsers) {
      usersValue.add(user.value!);
    }
    List<UserInfo> usersInfosValue = [];

    for (var user in usersValue) {
      UserInfo? userInfos = await UserInfoRepository().getByServerId(user);
      usersInfosValue.add(userInfos!);
    }

    ProjectInfo projectInfo = ProjectInfo(
      name: projectNameController.text,
      description: projectDescriptionController.text,
      status: EnumStatus.CREATED.getValue(),
      creator: creator!.id!,
      creationDate: now,
      lastUpdate: now,
      localId: null,
      id: null,
      users: usersValue,
      userInfos: usersInfosValue,
    );
    if (await NetworkUtils().isNetworkAvailable()) {
      Project project = await WebServiceManager().sendNewProject(projectInfo);
      await ProjectRepository().insert(project);
      for (var user in usersValue) {
        ProjectUser projectUser = ProjectUser(
          projectId: project.id!,
          userId: user,
          localId: null,
          id: null,
          creationDate: now,
          lastUpdate: now,
        );
        await ProjectUserRepository().insert(projectUser);
      }

      _validateFormNavigate(project.id!);
    } else {
      ViewUtils().showSnackbar(context, 'erreur réseau');
    }


  }

  //endregion

  //region Navigation

  _validateFormNavigate(int projectId) {
    ViewUtils().showSnackbar(context, 'Project créer avec succès');
    
    NavigationUtils().navigateTo(context, ProjectViewController(projectId: projectId,));
  }

  navigateBack() {
    Navigator.pop(context, true);
  }

//endregion

//endregion
}
