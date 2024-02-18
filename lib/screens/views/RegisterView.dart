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
import '../controllers/RegisterController.dart';


class RegisterView extends WidgetView<RegisterViewController, RegisterController> {
  const RegisterView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: true,
        appBar: const HeaderBar(
          customBackgroundColor: CustomColors.BACKGROUND_COLOR,
          title: "Inscription",
        ),

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

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
            key: controller.RegisterFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16),child: Text('Nom :', style: TextStyle(fontWeight: FontWeight.w700),),),
                FormInput.defaultInput(controller: controller.firstNameController, label: 'Nom d\'utilisateur'),
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16),child: Text('Prenom :', style: TextStyle(fontWeight: FontWeight.w700)),),
                FormInput.defaultInput(controller: controller.lastNameController, label: 'Nom d\'utilisateur'),
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16),child: Text('Email :', style: TextStyle(fontWeight: FontWeight.w700)),),

                FormInput.defaultInput(controller: controller.emailController, label: 'Nom d\'utilisateur'),
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16),child: Text('Mot de passe :', style: TextStyle(fontWeight: FontWeight.w700)),),

                FormInput.defaultInput(controller: controller.passwordController, label: 'Mot de passe', obscureText: controller.isPasswordVisible.value, onTogglePassword: controller.onTogglePassword(),),
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16),child: Text('Confirmer mot de passe :', style: TextStyle(fontWeight: FontWeight.w700)),),
                FormInput.defaultInput(controller: controller.confirmPasswordController, label: 'Confirmer mot de passe :', obscureText: controller.isPasswordVisible.value, onTogglePassword: controller.onTogglePassword(),),
                Padding(padding: EdgeInsets.only(top: Dimens.spacing_large_16, bottom: Dimens.spacing_medium_12),),

                Buttons.customButton(context: context, buttonTitle: "Valider", onPressedFunction: controller.onRegisterClicked),
                Padding(
                  padding: EdgeInsets.only(top: Dimens.spacing_large_16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Déja un compte ? "),
                      InkWell(
                        onTap: controller.onLoginClicked,
                        child: Text(
                          "connectez-vous",
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
