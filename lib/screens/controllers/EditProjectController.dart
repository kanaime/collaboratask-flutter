import 'dart:convert';

import 'package:collaboratask/database/models/UserInfo.dart';
import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/managers/SyncroManager.dart';
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
import '../../widgets/FormPopup.dart';
import '../views/EditProjectView.dart';

class EditProjectViewController extends StatefulWidget {
  const EditProjectViewController({super.key, required this.projectId});
  final int projectId;

  @override
  EditProjectController createState() {
    return EditProjectController();
  }
}

class EditProjectController extends State<EditProjectViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  late TextEditingController projectNameController;
  late TextEditingController projectDescriptionController;
  late TextEditingController projectStatusController;
  List<UserInfo> usersInfo = [];
  User? currentUser;
  List<ValueItem<int>> selectedUsers = [];
  ProjectInfo? currentProject;
  late ValueItem  selectedStatus;
  ValueNotifier<bool> showValidate = ValueNotifier(false);

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
    return EditProjectView(this);
  }

  showPopup({controller, function, label}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: FormPopup(
            onCanceledFunction: navigateBack,
            textEditingController: controller,
            onPressedFunction: function,
            label: label,
            formKey: formKey,


          ), // Remplacez MyForm() par votre formulaire
        );
      },
    );
  }
  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;
    var project = await ProjectRepository().getByServerId(widget.projectId);
    currentProject = await ProjectManager().convertProjectToProjectInfo(project!);

    currentUser = await UserManager().getCurrentUser();

    selectedStatus = ValueItem(label: EnumStatus.getStatusFromString(currentProject!.status).name, value: currentProject!.status);

    usersInfo = await UserInfoRepository().getAll();

    projectNameController.text = currentProject!.name;
    projectDescriptionController.text = currentProject!.description;

    isLoading.value = false;
  }
  getStatusOptions(List<EnumStatus> data){
    return EnumStatus.values.map((e) => ValueItem(label: e.name, value: e.getValue())).toList();
  }

  List<ValueItem<int>> getOptions(List<UserInfo> data) {
    List<ValueItem<int>> items = [];
    for (var user in data) {
      items.add(ValueItem(label: '${user.firstName}', value: user.id));
    }
    return items;
  }

  onSubmittedPopUp() async {
    print('submitted');

    if(currentProject?.creator == currentUser?.id){
      if(currentProject?.name != projectNameController.text || currentProject?.description != projectDescriptionController.text){
        showValidate.value = true;
        var jsonToSend = jsonEncode({
          "name": projectNameController.text,
          "description": projectDescriptionController.text
        });
        print("jsonToSend ${jsonToSend}");
        currentProject = await WebServiceManager().editProject(currentProject!.id!, jsonToSend);

        _validateFormNavigate();


      }
      else{
        showValidate.value = false;
      }
      print("project name ${projectNameController.text}");
      print("project description ${projectDescriptionController.text}");


      isLoading.value = true;

      //_EditProject();
      print("selected users ${selectedUsers}");

      _validateFormNavigate();

      isLoading.value = false;}
    else{
      ViewUtils().showSnackbar(context, 'Vous n\'avez pas les droits pour modifier ce projet');
      navigateBack();
    }

  }
  dropDownSubmitted() async{
    print('submitted');
    print("selected users ${selectedUsers.map((e) => e.value).toList()}");
    print("selected status ${selectedStatus}");
    showValidate.value = false;
    var jsonToSend = jsonEncode({
      "status": selectedStatus.value,
      "users": selectedUsers.map((e) => e.value).toList()
    });

    print("jsonToSend ${jsonToSend}");

    currentProject = await WebServiceManager().editProject(currentProject!.id!, jsonToSend);

    _validateFormNavigate();



  }

  //endregion

  //region Navigation

  _validateFormNavigate() async {
    await ProjectManager().setCurrentProject(widget.projectId);
    ViewUtils().showSnackbar(context, 'Project créer avec succès');


  navigateBack();
  }

  navigateBack() {
     Navigator.pop(context, currentProject?.id!);

  }

//endregion

//endregion
}
