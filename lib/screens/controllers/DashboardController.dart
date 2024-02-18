
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:flutter/material.dart';

import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/DashboardView.dart';
import 'MainNavigationControlller.dart';

class DashboardViewController extends StatefulWidget {
  const DashboardViewController({super.key});

  @override
  DashboardController createState() {
    return DashboardController();
  }
}

class DashboardController extends State<DashboardViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);


  //endregion

  // region Init
  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;



    isLoading.value = false;
  }


  //endregion

  //region Navigation
  _navigateToHomeController() async {

    NavigationUtils().navigateTo(context, const MainNavigationViewController());

  }
//endregion


//endregion
}
