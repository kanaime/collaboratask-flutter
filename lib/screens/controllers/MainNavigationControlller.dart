

import 'package:collaboratask/screens/controllers/AccountController.dart';
import 'package:collaboratask/screens/controllers/MessageController.dart';
import 'package:collaboratask/screens/controllers/TaskListController.dart';
import 'package:flutter/material.dart';

import '../views/MainNavigationView.dart';
import 'ProjectListController.dart';



enum MenuItem {
  accueil, list, messages, account
}

class MainNavigationViewController extends StatefulWidget {
  const MainNavigationViewController({super.key});


  static MainNavigationController? of(BuildContext context) =>
      context.findAncestorStateOfType<MainNavigationController>();

  @override
  MainNavigationController createState() {
    return MainNavigationController();
  }
}

class MainNavigationController extends State<MainNavigationViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<MenuItem> currentMenuItemDisplayed = ValueNotifier(MenuItem.accueil) ;
  Map<MenuItem, Widget> screens = {
    MenuItem.accueil:  TaskListViewController(),
    MenuItem.account:  AccountViewController(),
    MenuItem.messages:  MessageViewController(),
    MenuItem.list:  ProjectListViewController(),

  };

  //endregion

  // region Init
  @override
  void dispose() {
    isLoading.dispose();
    currentMenuItemDisplayed.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigationView(this);
  }

  //endregion

  //region Data
  void _loadData() async {

  }

  Widget? getCurrentDisplayedScreen() {
    return screens[currentMenuItemDisplayed.value] ;
  }

  //endregion

  //region User action
  didTapMenuItem(int index) {
    currentMenuItemDisplayed.value = MenuItem.values[index] ;
  }

  //endregion



  //region Navigation

  _navigateToProject() {

  }
//endregion

}