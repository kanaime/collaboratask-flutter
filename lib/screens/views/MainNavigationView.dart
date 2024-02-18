
import 'package:collaboratask/theme/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/view_utils.dart';
import '../base_view.dart';
import '../controllers/MainNavigationControlller.dart';


class MainNavigationView extends WidgetView<MainNavigationViewController, MainNavigationController> {
  const MainNavigationView(MainNavigationController state, {super.key}) : super(state);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ValueListenableBuilder(
          valueListenable: controller.currentMenuItemDisplayed,
          builder: (context, MenuItem currentMenuItemDisplayed, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
                value: ViewUtils().statusBarColorDark(Colors.transparent),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: _bottomMenu(context, currentMenuItemDisplayed),
                  body: controller.getCurrentDisplayedScreen(),
                ));
          }),
    );
  }

  //region Bottom Menu
  BottomNavigationBar _bottomMenu(BuildContext context, MenuItem currentMenuItemDisplayed) {
    var accueilMenuIconName = "images/ic-accueil.png";
    var listMenuIconName = "images/ic-liste.png";
    var messagesMenuIconName = "images/ic-message.png";
    var accountMenuIconName = "images/ic-profil.png";

    return BottomNavigationBar(
      backgroundColor: CustomColors.BOTTOM_NAVIGATION_BAR_COLOR,
      currentIndex: currentMenuItemDisplayed.index,
      onTap: controller.didTapMenuItem,
      selectedItemColor: CustomColors.LINK_ACTIVE,
      unselectedItemColor: CustomColors.BLACK,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, fontFamily: "arial"),
      unselectedLabelStyle: const TextStyle(fontSize: 10, fontFamily: "arial"),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        _bottomNavigationBarItem(context, iconName: Icons.home, label: "accueil"),
        _bottomNavigationBarItem(context, iconName: Icons.list, label: "taches"),
        _bottomNavigationBarItem(context, iconName: Icons.message, label: "messages"),
        _bottomNavigationBarItem(context, iconName: Icons.person, label: "profil"),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(BuildContext context, {required IconData iconName, required String label}) {
    var iconSize = 30.0;
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
        child: Icon(
          iconName,
          size: iconSize,
          color: CustomColors.LINK_ACTIVE,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
        child: Icon(
          iconName,
          size: iconSize,
          color: CustomColors.BLACK
        ),
      ),
      label: "",
    );
  }

//endregion
}
