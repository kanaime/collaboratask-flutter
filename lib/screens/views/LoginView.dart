import 'package:collaboratask/widgets/FormInput.dart';
import 'package:collaboratask/widgets/HeaderBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../../widgets/Buttons.dart';
import '../base_view.dart';
import '../controllers/LoginController.dart';


class LoginView extends WidgetView<LoginViewController, LoginController> {
  const LoginView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage("images/logo.png"),
                        width: Dimens.fromScreenWidth(context, coef: 0.85),
                      ),
                    ),
                    _content(context),

                  ],
                ),
              ),
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
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16),child: Text('Email :', style: TextStyle(fontWeight: FontWeight.w700)),),

                FormInput.defaultInput(controller: controller.emailController, label: 'Email'),
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16),child: Text('Mot de passe :', style: TextStyle(fontWeight: FontWeight.w700)),),

                FormInput.defaultInput(controller: controller.passwordController, label: 'Mot de passe', obscureText: controller.isPasswordVisible.value, onTogglePassword: controller.onTogglePassword(),),
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16, bottom: Dimens.spacing_medium_12),),

                Buttons.customButton(context: context, buttonTitle: "Valider", onPressedFunction: controller.onLoginClicked),

                Padding(
                  padding: EdgeInsets.only(top: Dimens.spacing_large_16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Vous n'avez pas de compte ? "),
                      InkWell(
                        onTap: controller.onSignUpClicked,
                        child: Text(
                          "Inscrivez-vous",
                          style: TextStyle(color: CustomColors.LINK_ACTIVE, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
          )),

    );
  }

//endregion


}
