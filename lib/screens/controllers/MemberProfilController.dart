
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:flutter/material.dart';

import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/MemberProfilView.dart';
import 'MainNavigationControlller.dart';

class MemberProfilViewController extends StatefulWidget {
  const MemberProfilViewController({super.key});

  @override
  MemberProfilController createState() {
    return MemberProfilController();
  }
}

class MemberProfilController extends State<MemberProfilViewController> {
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
    return MemberProfilView(this);
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
