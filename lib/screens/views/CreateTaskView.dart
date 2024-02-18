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
import '../controllers/CreateTaskController.dart';

class CreateTaskView extends WidgetView<CreateTaskViewController, CreateTaskController> {
  const CreateTaskView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: false,
        appBar: HeaderBar(
          title: '',
          backButton: true,
          onBackButtonPressed: controller.navigateBack,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(left: Dimens.spacing_large_16, right: Dimens.spacing_large_16, bottom: Dimens.spacing_xlarge_32),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: Dimens.spacing_medium_12, top: Dimens.spacing_large_16),
                        child: Text('Creer une nouvelle tache', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      ValueListenableBuilder(
                          valueListenable: controller.isLoading,
                          builder: (context, bool isLoading, child) {
                            if (isLoading) {
                              return CircularProgressIndicator();
                            }
                            return _content(context);
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //region Main content
  Widget _content(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _taskForm(context),
        ],
      ),
    );
  }

  Form _taskForm(BuildContext context) {
    return Form(
        key: controller.formKey,
        child: Column(
          children: [
            MultiSelectDropDown<dynamic>(
              inputDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: CustomColors.GRAY, width: 1.0),
              ),
              dropdownBackgroundColor: CustomColors.WHITE,
              borderColor: CustomColors.BLACK,
              fieldBackgroundColor: CustomColors.WHITE,
              hint: controller.project!.name ?? 'Selectionner un projet',
              hintStyle: TextStyle(fontSize: 12, color: CustomColors.TEXT_COLOR_DARK.withOpacity(0.7)),
              onOptionSelected: (List<ValueItem> selectedOptions) {
                controller.selectedProject = selectedOptions.single;
              },
              options: controller.getOptions(controller.projects),
              selectionType: SelectionType.single,
              chipConfig: const ChipConfig(wrapType: WrapType.scroll),
              dropdownHeight: 300,
              searchEnabled: true,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            SizedBox(height: 20),
            FormInput.defaultInput(controller: controller.taskNameController, label: 'Nom de la tache'),
            SizedBox(height: 20),
            FormInput.defaultInput(controller: controller.taskDescriptionController, label: 'Description de la tache'),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Buttons.defaultButton(context: controller.context, buttonTitle: 'Valider', onPressedFunction: controller.onSubmitted),
          ],
        ));
  }

//endregion
}
