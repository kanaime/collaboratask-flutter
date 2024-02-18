import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../../widgets/CircleUserAvatar.dart';
import '../../widgets/HeaderBar.dart';
import '../base_view.dart';
import '../controllers/AccountController.dart';

class AccountView extends WidgetView<AccountViewController, AccountController> {
  const AccountView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: ViewUtils().statusBarColorDark(Colors.transparent),
        child: Scaffold(
          backgroundColor: CustomColors.BACKGROUND_COLOR,
          resizeToAvoidBottomInset: false,
          appBar: const HeaderBar(
            customBackgroundColor: CustomColors.BACKGROUND_COLOR,
            title: "Account",
          ),
          body: ValueListenableBuilder(
            valueListenable: controller.isLoading,
            builder: (context, bool isLoading, child) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_large_16, vertical: Dimens.spacing_large_16),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _content(context),
                      deconnexionInput(),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  //region Main content
  Widget _content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleUserAvatar(
                    user: controller.userInfo,
                    radius: 70,

                  ),
                  Positioned(
                    bottom: -5,
                    right: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: CustomColors.LIGHT_BLACK,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: CustomColors.BACKGROUND_COLOR, width: 1),
                          ),
                          child: Icon(Icons.add_a_photo_outlined, color: CustomColors.WHITE, size: 30)),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${controller.user?.firstName} ${controller.user?.lastName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomColors.BLACK)),
                    Text(controller.user!.email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: CustomColors.LIGHT_BLACK)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_large_16),
          child: Text("Mon compte", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomColors.BLACK.withOpacity(0.9))),
        ),
        Column(
          children: [
            Column(
              children: [
                accountItemLink(icon: Icons.person, text: 'Profil', onTap: controller.didTapOnEditProfil),
                accountItemLink(icon: Icons.settings, text: 'Paramètres', onTap: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }

  deconnexionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_normal_8),
      child: Material(
        color: CustomColors.WHITE,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: CustomColors.GRAY,
          onTap: () {
            controller.didTapOnLogout();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.spacing_medium_12, horizontal: Dimens.spacing_large_16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Déconnexion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColors.TEXT_COLOR_RED)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  accountItemLink({required icon, required text, required onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_normal_8),
      child: Material(
        color: CustomColors.WHITE,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: CustomColors.GRAY,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_medium_12, horizontal: Dimens.spacing_large_16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(icon),
                    ),
                    Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColors.TEXT_COLOR_DARK)),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: CustomColors.GRAY, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

//endregion
}
