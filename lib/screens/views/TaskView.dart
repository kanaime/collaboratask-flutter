import 'package:collaboratask/ressources/enum/EnumStatus.dart';
import 'package:collaboratask/widgets/CircleUserAvatar.dart';
import 'package:collaboratask/widgets/HeaderBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../base_view.dart';
import '../controllers/TaskController.dart';


class TaskView extends WidgetView<TaskViewController, TaskController> {
  const TaskView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        appBar: HeaderBar(
          title: '',
          backButton: true,
          onBackButtonPressed: controller.navigateBack,
          rightButton: IconButton(
            icon: const Icon(Icons.edit, color: CustomColors.SECONDARY, size: 24,),
            onPressed: controller.didTapOnEdit,),
        ),
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
    );
  }

  //region Main content
  Widget _content(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(left: Dimens.spacing_large_16, right: Dimens.spacing_large_16, bottom: Dimens.spacing_xlarge_32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Dimens.spacing_medium_12, top: Dimens.spacing_large_16),
                child: Text('Tache numéro ${controller.task?.id}${controller.task?.localId} :  ${controller.task?.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _taskDescription(),
                        ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleUserAvatar(
                          user: controller.creator,
                          radius: 40,
                          ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Créateur", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
                          Text("${controller.creator?.firstName} ${controller.creator?.lastName}", style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY)),
                        ],
                      ),

                    ],
                  ),

                ],
              ),

              _dateAndCountTask(),
              Text("Progression :", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(value: EnumStatus.getStatusFromString(controller.task!.status).getPercent(), backgroundColor: CustomColors.GRAY, valueColor: const AlwaysStoppedAnimation<Color>(CustomColors.PRIMARY_BLUE_02AACC)),
              ),
            ],

          )),
    );
  }



  _taskDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description :", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.spacing_medium_12),
          child: Text(controller.task!.description, style: const TextStyle(fontSize: 16)),
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
                Text(controller.task!.parseCreationDate(), style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY)),
              ],
            ),
            Row(
              children: [
                Text("Status : ", style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY)),
                const SizedBox(
                  width: 4,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal:Dimens.spacing_normal_8, vertical: Dimens.spacing_small_4),
                    decoration: BoxDecoration(
                      color: CustomColors.SECONDARY,
                      borderRadius: BorderRadius.circular(Dimens.border_radius_medium),
                    ),
                    child: Text(EnumStatus.getStatusFromString(controller.task!.status).name , style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_LIGHT)))
              ],
            )
          ],
        ),
      ),
    );
  }
//endregion


}
