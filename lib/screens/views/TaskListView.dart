import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/managers/TaskManager.dart';
import 'package:collaboratask/ressources/enum/EnumFilter.dart';
import 'package:collaboratask/widgets/CircleUserAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../database/models/Task.dart';
import '../../database/models/User.dart';
import '../../database/models/UserInfo.dart';
import '../../ressources/enum/EnumStatus.dart';
import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../../widgets/HeaderBar.dart';
import '../base_view.dart';
import '../controllers/TaskListController.dart';

class TaskListView extends WidgetView<TaskListViewController, TaskListController> {
  const TaskListView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorLight(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: false,
        appBar: HeaderBar(
          customBackgroundColor: CustomColors.BACKGROUND_COLOR,
          title: "Home",
          rightButton: CircleAvatar(
              backgroundColor: CustomColors.PRIMARY, child: IconButton(onPressed: controller.didPressOnAddBarButton, icon: const Icon(Icons.add, color: CustomColors.WHITE))),
        ),
        body: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: Dimens.spacing_medium_12, bottom: Dimens.spacing_medium_12),
            child: _searchBar(context),
          ),
          Expanded(
            child: SingleChildScrollView(child: _content(context)),
          ),
        ]),
      ),
    );
  }

  //region Search bar
  Widget _searchBar(BuildContext context) {
    var searchBarHeight = 44.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_large_16),
      child: SearchBar(
        controller: controller.searchBarController,
        hintText: "Rechercher un projet",
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        backgroundColor: MaterialStateProperty.resolveWith((states) => CustomColors.SEARCH_BAR_COLOR),
        overlayColor: MaterialStateProperty.resolveWith((states) => CustomColors.SEARCH_BAR_COLOR),
        textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(color: CustomColors.TEXT_COLOR_DARK)),
        shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))),
        constraints: BoxConstraints(minHeight: searchBarHeight, maxHeight: searchBarHeight),
        leading: const Padding(
          padding: EdgeInsets.only(left: Dimens.spacing_normal_8),
          child: Icon(
            Icons.search,
            color: CustomColors.TEXT_COLOR_DARK,
          ),
        ),
        trailing: [_closeButton()],
        onChanged: (searchText) {
          controller.didSearchText(searchText);
        },
      ),
    );
  }

  Widget _closeButton() {
    return ValueListenableBuilder(
        valueListenable: controller.searchBarIsEmpty,
        builder: (context, bool hideCloseButton, child) {
          if (hideCloseButton) return Container();

          return IconButton(
            icon: const Icon(Icons.clear),
            iconSize: 24,
            onPressed: controller.didPressOnClearBarButton,
          );
        });
  }
  //endregion

  //region Main content
  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_large_16),
      child: ValueListenableBuilder(
        valueListenable: controller.isLoading,
        builder: (context, bool isLoading, child) {
          return RefreshIndicator(
            onRefresh: controller.didPullToRefresh,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.all(Dimens.spacing_large_16),
                child: Text("Aujourd'hui", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomColors.BLACK)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: Dimens.spacing_large_16),
                child: ValueListenableBuilder(
                  valueListenable: controller.searchBarIsEmpty,
                  builder: (context, bool isEmpty, child) {
                    if (isEmpty) {
                      return _gridView(context);
                    }
                    return Container();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.spacing_large_16),
                      child: Text("${controller.taskFiltered.length} Tâches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomColors.BLACK)),
                    ),
                  ),
                  DropdownButton<EnumFilter>(
                    value: controller.selectedStatus,
                    onChanged: (EnumFilter? newValue) {


                        controller.filterTaskByStatus(newValue!);

                    },
                    items: [

                      for (EnumFilter status in EnumFilter.values)
                        DropdownMenuItem(
                          value: status,
                          child: Text(status.name),
                        ),
                    ],
                  ),
                  //_dropDown(),
                ],
              ),
              _taskList(context)
            ]),
          );
        },
      ),
    );
  }



  Widget _gridView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _cardInfo(context, controller.getCountTaskByStatus(EnumStatus.values[index]), controller.cardNames[index], controller.colors[index]);
      },
    );
  }

  _taskList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.taskFiltered.length,
      itemBuilder: (context, index) {
        var task = controller.taskFiltered[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.WHITE,
              border: Border.all(color: CustomColors.GRAY, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              onTap: () => controller.didTapOnTask(task.id!),
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
                    child: Icon(Icons.person),
                  );
                },
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: CustomColors.TEXT_COLOR_GRAY, size: 16),
            ),
          ),
        );
      },
    );
  }

  _cardInfo(BuildContext context, value, label, color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("images/logo.png"),
          //fit: BoxFit.cover,
          opacity: 0.1,
          alignment: Alignment.topRight,
        ),
        color: color,
        border: Border.all(color: CustomColors.GRAY, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(label, style: TextStyle(fontSize: 18, color: CustomColors.TEXT_COLOR_LIGHT)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.TEXT_COLOR_LIGHT)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
