import 'package:collaboratask/ressources/enum/EnumStatus.dart';
import 'package:collaboratask/widgets/FormInput.dart';
import 'package:collaboratask/widgets/HeaderBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../database/models/modelsView/ProjectInfo.dart';
import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../../widgets/Buttons.dart';
import '../base_view.dart';
import '../controllers/EditProjectController.dart';

class EditProjectView extends WidgetView<EditProjectViewController, EditProjectController> {
  const EditProjectView(super.state, {super.key});

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
          rightButton: ValueListenableBuilder(
            valueListenable: controller.showValidate,
            builder: (context, bool isShowed, child) {
              if(isShowed){
                return TextButton(onPressed: controller.dropDownSubmitted, child: const Text("Terminer", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),));
              }else{  return Container();}

            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: controller.isLoading,
                    builder: (context, bool isLoading, child) {
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _content(context, controller.currentProject!);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //region Main content
  Widget _content(BuildContext context, ProjectInfo project) {
    return Padding(
      padding: const EdgeInsets.only(left: Dimens.spacing_large_16, right: Dimens.spacing_large_16, bottom: Dimens.spacing_xlarge_32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: Dimens.spacing_normal_8),
            child: Text(
              'Modifier le projet',
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

                editItem(project, 'Nom', controller.projectNameController, project.name),
                editItem(project, 'Description', controller.projectDescriptionController, project.description),



                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: Dimens.spacing_large_16, top: Dimens.spacing_small_4),
                      child: Text(
                        'Status',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.TEXT_COLOR_DARK),),
                    ),

                    MultiSelectDropDown<dynamic>(
                      inputDecoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: CustomColors.BACKGROUND_COLOR, width: 1)),
                      ),
                      dropdownBackgroundColor: CustomColors.WHITE,
                      borderColor: CustomColors.BLACK,
                      fieldBackgroundColor: CustomColors.WHITE,
                      hint: project.status,
                      hintStyle: TextStyle(fontSize: 12, color: CustomColors.TEXT_COLOR_DARK.withOpacity(0.7)),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        controller.selectedStatus = selectedOptions.single;
                        controller.showValidate.value = true;


                      },
                      options: controller.getStatusOptions(EnumStatus.values),
                      selectionType: SelectionType.single,
                      chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: Dimens.spacing_large_16, top: Dimens.spacing_small_4),
                      child: Text(
                        'membres',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.TEXT_COLOR_DARK),),
                    ),

                    MultiSelectDropDown<int>(
                      inputDecoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: CustomColors.BACKGROUND_COLOR, width: 1)),
                      ),
                      dropdownBackgroundColor: CustomColors.WHITE,
                      borderColor: CustomColors.BLACK,
                      fieldBackgroundColor: CustomColors.WHITE,
                      searchEnabled: true,
                      hint: 'Sélectionner les membres',
                      hintStyle: TextStyle(fontSize: 12, color: CustomColors.TEXT_COLOR_DARK.withOpacity(0.7)),
                      onOptionSelected: (List<ValueItem<int>> selectedOptions) {
                        controller.selectedUsers = selectedOptions;
                        controller.showValidate.value = true;

                        print(controller.selectedUsers.map((e) => e.value).toList());
                      },
                      options: controller.getOptions(controller.usersInfo),
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),


                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container editItem(ProjectInfo project, labelItem, controllerItem, projectInfo) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labelItem,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.TEXT_COLOR_DARK),
                    ),
                    Text(
                      projectInfo,
                      style: TextStyle(fontSize: 16, color: CustomColors.TEXT_COLOR_LIGHT_DARK.withOpacity(0.7)),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: CustomColors.TEXT_COLOR_LIGHT_DARK),

              ],
            ),
          ),
        );
  }

//endregion
}
