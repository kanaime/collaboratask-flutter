import 'package:collaboratask/widgets/FormInput.dart';
import 'package:collaboratask/widgets/HeaderBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../database/models/Task.dart';
import '../../database/models/User.dart';
import '../../ressources/enum/EnumStatus.dart';
import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../../widgets/Buttons.dart';
import '../base_view.dart';
import '../controllers/EditProfilController.dart';

class EditProfilView extends WidgetView<EditProfilViewController, EditProfilController> {
  const EditProfilView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        appBar: HeaderBar(
          customBackgroundColor: CustomColors.BACKGROUND_COLOR,
          title: "",
          backButton: true,
          onBackButtonPressed: controller.navigateBack,
        ),
        body: SafeArea(
          child: SingleChildScrollView(

            child: ValueListenableBuilder(
              valueListenable: controller.isLoading,
              builder: (context, bool isLoading, child) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _content(context, controller.currentUser!);
              },
            ),
          ),
        ),
      ),
    );
  }

  //region Main content
  Widget _content(BuildContext context, User Task) {
    return Padding(
      padding: const EdgeInsets.only(left: Dimens.spacing_large_16, right: Dimens.spacing_large_16, bottom: Dimens.spacing_xlarge_32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: Dimens.spacing_normal_8),
            child: Text(
              'Modifier mon profil :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.TEXT_COLOR_DARK),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.WHITE,
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                editItem(Task, 'Nom', controller.UserFirstNameController, Task.firstName),
                editItem(Task, 'Prénom', controller.UserLastNameController, Task.lastName),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Container editItem(User Task, labelItem, controllerItem, TaskInfo) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CustomColors.BACKGROUND_COLOR, width: 1)),
      ),
      child: ListTile(
        onTap: () {
          controller.showPopup(controller: controllerItem,function: controller.onSubmittedPopUp, label: labelItem);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelItem,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.TEXT_COLOR_DARK),
                  ),
                  Text(
                    TaskInfo,
                    style: TextStyle(fontSize: 16, color: CustomColors.TEXT_COLOR_LIGHT_DARK.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: CustomColors.TEXT_COLOR_LIGHT_DARK),

          ],
        ),
      ),
    );
  }

//endregion
}
