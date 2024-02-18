import 'package:collaboratask/widgets/FormInput.dart';
import 'package:collaboratask/widgets/HeaderBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../../widgets/Buttons.dart';
import '../base_view.dart';
import '../controllers/CreateProjectController.dart';

class CreateProjectView extends WidgetView<CreateProjectViewController, CreateProjectController> {
  const CreateProjectView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        appBar: HeaderBar(
          customBackgroundColor: CustomColors.BACKGROUND_COLOR,
          title: "Nouveau Projet",
          backButton: true,
          onBackButtonPressed: controller.navigateBack,
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
                      return _content(context);
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
  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Dimens.spacing_large_16, right: Dimens.spacing_large_16, bottom: Dimens.spacing_xlarge_32),
      child: Column(
        children: [
          Image.asset('images/logo.png', width: 200, height: 200),
          Form(
            key: controller.formKey,
            child: Column(
              children: [
                FormInput.defaultInput(controller: controller.projectNameController, label: 'Nom du projet'),
                const SizedBox(
                  height: Dimens.spacing_medium_12,
                ),
                FormInput.defaultInput(controller: controller.projectDescriptionController, label: 'Description'),
                const SizedBox(
                  height: Dimens.spacing_medium_12,
                ),
                SizedBox(
                  height: Dimens.spacing_medium_12,
                ),
                MultiSelectDropDown<int>(
                  dropdownBackgroundColor: CustomColors.WHITE,
                  borderColor: CustomColors.BLACK,
                  fieldBackgroundColor: CustomColors.BACKGROUND_COLOR,
                  searchEnabled: true,
                  hint: 'Sélectionner les membres',
                  hintStyle: TextStyle(fontSize: 12, color: CustomColors.TEXT_COLOR_DARK.withOpacity(0.7)),
                  onOptionSelected: (List<ValueItem<int>> selectedOptions) {
                    controller.selectedUsers = selectedOptions;

                    print(controller.selectedUsers.map((e) => e.value).toList());
                  },
                  options: controller.getOptions(controller.usersInfo),
                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                  dropdownHeight: 300,
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:Dimens.spacing_xlarge_32),
                  child: Buttons.defaultButton(context: controller.context, buttonTitle: 'Valider', onPressedFunction:  ()=>controller.onSubmitted()),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

//endregion
}
