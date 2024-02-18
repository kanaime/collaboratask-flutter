import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/ressources/enum/EnumStatus.dart';
import 'package:collaboratask/widgets/CircleUserAvatar.dart';
import 'package:collaboratask/widgets/CircularPercentProject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../theme/TextStyles.dart';
import '../../utils/view_utils.dart';
import '../../widgets/Buttons.dart';
import '../../widgets/HeaderBar.dart';
import '../base_view.dart';
import '../controllers/ProjectController.dart';

class ProjectView extends WidgetView<ProjectViewController, ProjectController> {
  const ProjectView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: false,
        appBar:  HeaderBar(
          customBackgroundColor: CustomColors.BACKGROUND_COLOR,
          title: "",
          backButton: true,
          onBackButtonPressed: controller.navigateBack,
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: controller.isLoading,
                        builder: (context, bool isLoading, child) {
                          if (isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return _content(context);
                        }),
                  ],
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
    return Padding(
        padding: const EdgeInsets.only(left: Dimens.spacing_large_16, right: Dimens.spacing_large_16, bottom: Dimens.spacing_xlarge_32),
        child: Column(

          children: [
            _projectCard(context),
            _taskList(context),
            //_button(context),
          ],
        ));
  }

  _projectCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: Dimens.spacing_medium_12),
              child: Text(controller.project!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
            ),
            if(controller.creator?.id == controller.user?.id)
              IconButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.border_radius_medium))),
                  backgroundColor: MaterialStateProperty.all(CustomColors.PRIMARY),
                ),
                onPressed: controller.didTapOnEdit, icon: const Icon(
                Icons.edit_rounded,
                color: CustomColors.BLACK,
              ),)
          ],
        ),
        Text(controller.project!.description, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: CustomColors.TEXT_COLOR_DARK)),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Membres", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                  ),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: _listUserForProject(),
                  ),
                ],
              ),
            ),
            _percentageTask(),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Créateur", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
            Text("${controller.creator?.firstName} ${controller.creator?.lastName}", style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: Dimens.spacing_medium_12, bottom: Dimens.spacing_medium_12),
          child: Row(
            children: [
              const Expanded(
                child: Text("Status : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal:Dimens.spacing_normal_8, vertical: Dimens.spacing_small_4),
                  decoration: BoxDecoration(
                    color: CustomColors.SECONDARY,
                    borderRadius: BorderRadius.circular(Dimens.border_radius_medium),
                  ),
                  child: Text(controller.project!.status , style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_LIGHT)))
            ],
          ),
        ),
        _dateAndCountTask(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_medium_12),
          child: Row(
            children: [
              const Text("Ajouter une tache", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
              IconButton(
                onPressed: controller.didTapOnAddTask,
                icon: const Icon(Icons.add_circle_rounded, color: CustomColors.SECONDARY, size: 24),
              ),


            ],

          ),
        )

      ],
    );
  }

  _listUserForProject() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: controller.project!.userInfos?.length,
      itemBuilder: (context, index) {
        var user = controller.project!.userInfos![index];
        return CircleUserAvatar(
          user: user,
          radius: 20,
          );
      },
    );
  }

  _percentageTask() {
    return Column(
      children: [
        CirclePercentPrject(project: controller.project!, getPercentage: controller.getPercentage()),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("Progression", style: TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_LIGHT_DARK)),
        ),
      ],
    );
  }

  Container _dateAndCountTask() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CustomColors.GRAY, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: CustomColors.TEXT_COLOR_GRAY,
                  size: 16,
                ),
                Text(controller.project!.parseCreationDate(), style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY)),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.check_box,
                  color: CustomColors.TEXT_COLOR_GRAY,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text("${controller.tasksProject.length} tâches", style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY))
              ],
            )
          ],
        ),
      ),
    );
  }

  _taskList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.tasksProject.length,
      itemBuilder: (context, index) {
        var task = controller.tasksProject[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.WHITE,
              border: Border.all(color: CustomColors.GRAY, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              onTap: () => controller.navigateToTask(task.id!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tâche ${task.name} ${task.id.toString()} ${task.localId.toString()}", style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_DARK)),
                  Text("${task.description}", style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: LinearPercentIndicator(
                      barRadius: const Radius.circular(8),
                      lineHeight: 8.0,
                      percent: EnumStatus.getStatusFromString(task.status).getPercent(),
                      progressColor: Colors.green,
                    ),
                  )
                ],
              ),
              leading: FutureBuilder(
                future: controller.getTaskCreator(task.creator),
                builder: (context, snapshot) {
                 if (snapshot.hasData) {
                   return CircleUserAvatar(
                     user: snapshot.data,
                     radius: 20,
                   );
                  }
                  return const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),);
                },
              ),

              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: CustomColors.TEXT_COLOR_GRAY, size: 16),
            ),
          ),
        );
      },
    );
  }



//endregion
}
