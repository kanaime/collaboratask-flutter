import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/widgets/CircleUserAvatar.dart';
import 'package:collaboratask/widgets/CircularPercentProject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../database/models/Project.dart';
import '../../database/models/User.dart';
import '../../database/models/UserInfo.dart';
import '../../database/models/modelsView/ProjectInfo.dart';
import '../../ressources/enum/EnumStatus.dart';
import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../../widgets/HeaderBar.dart';
import '../base_view.dart';
import '../controllers/ProjectListController.dart';

class ProjectListView extends WidgetView<ProjectListViewController, ProjectListController> {
  const ProjectListView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorLight(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: false,
        appBar: HeaderBar(
          customBackgroundColor: CustomColors.BACKGROUND_COLOR,
          title: "Projets",
          rightButton: CircleAvatar(
            backgroundColor: CustomColors.PRIMARY,
              child: IconButton(onPressed: controller.didPressOnAddBarButton, icon: const Icon(Icons.add, color: CustomColors.WHITE))),
        ),
        body: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: Dimens.spacing_medium_12),
            child: _searchBar(context),
          ),
          const Padding(
            padding: EdgeInsets.all(Dimens.spacing_large_16),
            child: Text("Mes Projets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomColors.BLACK)),
          ),
          Expanded(child: _content(context)),
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
            onPressed:
              controller.didPressOnClearBarButton
            ,
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
          return RefreshIndicator(onRefresh: controller.didPullToRefresh, child: _listMissionCard(context));
        },
      ),
    );
  }

  Widget _listMissionCard(BuildContext context) {
    return ListView.builder(
      itemCount: controller.projectFiltered.length,
      itemBuilder: (BuildContext context, int index) {
        var item = controller.projectFiltered[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_normal_8),
          child: _projectCard(context, item),
        );
      },
    );
  }

  Widget _projectCard(BuildContext context, ProjectInfo project) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.border_radius_large),
      ),
      color: CustomColors.WHITE,
      child: InkWell(
        onTap: () {controller.onTapProject(project.id!);},
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacing_medium_12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(project.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(project.description, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: CustomColors.TEXT_COLOR_DARK)),
                        ),
                        const Text("Membres", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: _listUserForProject(project),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                          //project.status
                          EnumStatus.getStatusFromString(project.status).name, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: CustomColors.TEXT_COLOR_GRAY)),
                      _percentageTask(project),
                    ],
                  ),
                ],
              ),
              _dateAndCountTask(project)
            ],
          ),
        ),
      ),
    );
  }

  Container _dateAndCountTask(ProjectInfo project) {
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
                Text(project.parseCreationDate(), style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY)),
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
                FutureBuilder(
                    future: controller.getCountTaskByProject(project.id!),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data} tâches", style: const TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY));
                      } else {
                        return const Text("0 tâches", style: TextStyle(fontSize: 14, color: CustomColors.TEXT_COLOR_GRAY));
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

   _percentageTask(ProjectInfo project) {
    return CirclePercentPrject(project: project, getPercentage: controller.getPercentage(project.id!));
  }

   _listUserForProject(ProjectInfo project) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _userCard(project.userInfos!),
      ],
    );
  }

  _userCard(List<UserInfo> users) {
    return ListView.builder(
      itemCount: users.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        var user = users[index];
        return CircleUserAvatar(
          user: user,
          radius: 15,
        );
      },
    );
  }
}
