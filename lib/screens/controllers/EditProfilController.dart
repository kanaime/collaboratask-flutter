import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../database/models/User.dart';
import '../../database/models/User.dart';
import '../../database/models/modelsView/ProjectInfo.dart';
import '../../managers/UserManager.dart';
import '../../managers/WebServiceManager.dart';
import '../../ressources/enum/EnumStatus.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../../utils/view_utils.dart';
import '../../widgets/FormPopup.dart';
import '../views/EditProjectView.dart';
import '../views/EditProfilView.dart';

class EditProfilViewController extends StatefulWidget {
  const EditProfilViewController({super.key});
 

  @override
  EditProfilController createState() {
    return EditProfilController();
  }
}

class EditProfilController extends State<EditProfilViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  late TextEditingController UserFirstNameController;
  late TextEditingController UserLastNameController;
  User? currentUser;
  

  //endregion

  // region Init
  @override
  void dispose() {
    UserFirstNameController.dispose();
    UserLastNameController.dispose();
    isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    UserFirstNameController = TextEditingController();
    UserLastNameController = TextEditingController();


    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EditProfilView(this);
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


    currentUser = await UserManager().getCurrentUser();

    UserFirstNameController.text = currentUser!.firstName;
    UserLastNameController.text = currentUser!.lastName;

    isLoading.value = false;
  }
  getStatusOptions(List<EnumStatus> data){
    return EnumStatus.values.map((e) => ValueItem(label: e.name, value: e.getValue())).toList();
  }


  onSubmittedPopUp() async {
    print('submitted');

      if(currentUser?.firstName != UserFirstNameController.text || currentUser?.lastName != UserLastNameController.text){

        var jsonToSend = jsonEncode({
          "firstName": UserFirstNameController.text,
          "lastName": UserLastNameController.text
        });
        print("jsonToSend ${jsonToSend}");
        currentUser = await WebServiceManager().editUser(currentUser!.id!, jsonToSend);
        _validateFormNavigate();
      }
      isLoading.value = true;
      _validateFormNavigate();
      isLoading.value = false;}



  //endregion

  //region Navigation

  _validateFormNavigate() async {

    await ViewUtils().showSnackbar(context, 'Profil modifié avec succès');


    navigateBack();
  }

  navigateBack() {
    Navigator.pop(context, true);

  }

//endregion

//endregion
}
