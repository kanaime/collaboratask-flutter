import 'dart:convert';

import 'package:collaboratask/database/models/UserInfo.dart';
import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/managers/TaskManager.dart';
import 'package:collaboratask/managers/SyncroManager.dart';
import 'package:collaboratask/managers/UserManager.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/screens/controllers/TaskController.dart';
import 'package:collaboratask/widgets/FormPopup.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../database/models/Task.dart';
import '../../database/models/User.dart';
import '../../database/models/modelsView/ProjectInfo.dart';
import '../../ressources/enum/EnumStatus.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../../utils/view_utils.dart';
import '../views/EditProjectView.dart';
import '../views/EditTaskView.dart';

class EditTaskViewController extends StatefulWidget {
  const EditTaskViewController({super.key, required this.TaskId});
  final int TaskId;

  @override
  EditTaskController createState() {
    return EditTaskController();
  }
}

class EditTaskController extends State<EditTaskViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  late TextEditingController TaskNameController;
  late TextEditingController TaskDescriptionController;
  User? currentUser;
  Task? currentTask;
  late ValueItem  selectedStatus;
  ValueNotifier<bool> showValidate = ValueNotifier(false);

  //endregion

  // region Init
  @override
  void dispose() {
    TaskNameController.dispose();
    TaskDescriptionController.dispose();
    isLoading.dispose();
    showValidate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    TaskNameController = TextEditingController();
    TaskDescriptionController = TextEditingController();


    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EditTaskView(this);
  }

  showPopup({controller, function, label}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: FormPopup(
            onCanceledFunction: Navigator.of(context).pop,
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

    currentTask = await TaskRepository().getByServerId(widget.TaskId);

    currentUser = await UserManager().getCurrentUser();

    selectedStatus = ValueItem(label: EnumStatus.getStatusFromString(currentTask!.status).name, value: currentTask!.status);


    TaskNameController.text = currentTask!.name;
    TaskDescriptionController.text = currentTask!.description;

    isLoading.value = false;
  }
  getStatusOptions(List<EnumStatus> data){
    return EnumStatus.values.map((e) => ValueItem(label: e.name, value: e.getValue())).toList();
  }


  onSubmittedPopUp() async {
    print('submitted');

    if(currentTask?.creator == currentUser?.id){
      if(currentTask?.name != TaskNameController.text || currentTask?.description != TaskDescriptionController.text){
        showValidate.value = true;
        var jsonToSend = jsonEncode({
          "name": TaskNameController.text,
          "description": TaskDescriptionController.text
        });
        print("jsonToSend ${jsonToSend}");
        currentTask = await WebServiceManager().editTask(currentTask!.id!, jsonToSend);

        _validateFormNavigate();


      }
      else{
        showValidate.value = false;
      }
      print("Task name ${TaskNameController.text}");
      print("Task description ${TaskDescriptionController.text}");


      isLoading.value = true;

      _validateFormNavigate();

      isLoading.value = false;}
    else{
      ViewUtils().showSnackbar(context, 'Vous n\'avez pas les droits pour modifier ce projet');
      navigateBack();
    }

  }
  dropDownSubmitted() async{
    print('submitted');
    print("selected status ${selectedStatus}");
    showValidate.value = false;
    var jsonToSend = jsonEncode({
      "status": selectedStatus.value,
    });

    print("jsonToSend ${jsonToSend}");

    currentTask = await WebServiceManager().editTask(currentTask!.id!, jsonToSend);

    _validateFormNavigate();



  }

  //endregion

  //region Navigation

  _validateFormNavigate() async {
    await TaskManager().setCurrentTask(widget.TaskId);
    ViewUtils().showSnackbar(context, 'Tache modifiée créer avec succès');


    navigateBack();
  }

  navigateBack() {
    Navigator.pop(context, currentTask?.id!);

  }

//endregion

//endregion
}
