
import 'package:collaboratask/managers/FirebaseAuthManager.dart';
import 'package:collaboratask/managers/SyncroManager.dart';
import 'package:collaboratask/managers/UserManager.dart';
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/screens/controllers/LoginController.dart';
import 'package:collaboratask/utils/view_utils.dart';
import 'package:flutter/material.dart';

import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/SplashView.dart';
import 'MainNavigationControlller.dart';

class SplashViewController extends StatefulWidget {
  const SplashViewController({super.key});

  @override
  SplashController createState() {
    return SplashController();
  }
}

class SplashController extends State<SplashViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? versionText;

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
    return SplashView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;

    if(await UserManager().getCurrentUser() == null){
      _navigateToLoginController();
    }else{
      await SyncroManager().syncData();
      _navigateToHomeController();
    }

    // effectue la synchro des données
    isLoading.value = false;

  }

  _navigateToLoginController() {
    NavigationUtils().navigateTo(context, const LoginViewController());
  }

  //endregion

  //region Navigation
  _navigateToHomeController() async {

      NavigationUtils().navigateTo(context, const SplashViewController());

  }
  //endregion


//endregion
}
