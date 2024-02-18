
import 'package:collaboratask/database/models/UserInfo.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/screens/controllers/EditProjectController.dart';
import 'package:collaboratask/screens/controllers/SplashController.dart';
import 'package:flutter/material.dart';

import '../../database/models/User.dart';
import '../../managers/UserManager.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/AccountView.dart';
import 'EditProfilController.dart';
import 'MainNavigationControlller.dart';

class AccountViewController extends StatefulWidget {
  const AccountViewController({super.key});

  @override
  AccountController createState() {
    return AccountController();
  }
}

class AccountController extends State<AccountViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? versionText;
  User? user;
  UserInfo? userInfo;

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
    return AccountView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;
    user  = await UserManager().getCurrentUser();
    userInfo = await UserInfoRepository().getByServerId(user!.id!);

    isLoading.value = false;
  }
  //endregion
//region User Actions
didTapOnEditProfil(){
    navigateToEditProfil();
}
didTapOnLogout() async{
   await UserManager().logout();
    await NavigationUtils().navigateToWithReplacementWithRoot(context, SplashViewController());
  }


  //region Navigation

navigateToEditProfil() {
    NavigationUtils().navigateTo(context, EditProfilViewController()).then((value) {
      setState(() {
        _loadData();
      });
    });
  }


//endregion
}
