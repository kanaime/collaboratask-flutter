import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:collaboratask/screens/controllers/LoginController.dart';
import 'package:collaboratask/utils/view_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/RegisterView.dart';
import 'MainNavigationControlller.dart';

class RegisterViewController extends StatefulWidget {
  const RegisterViewController({super.key});

  @override
  RegisterController createState() {
    return RegisterController();
  }
}

class RegisterController extends State<RegisterViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(true);
  final RegisterFormKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //endregion

  // region Init
  @override
  void dispose() {
    isLoading.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;
    if(kDebugMode){
      firstNameController.text = "test";
      lastNameController.text = "test";
      emailController.text = "test@test.com";
      passwordController.text = "test1234.";
      confirmPasswordController.text = "test1234.";
    }

    isLoading.value = false;
  }
  //endregion

  //region User Actions

  onTogglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  onRegisterClicked() async {
    if (RegisterFormKey.currentState!.validate()) {
      print("isValidate");
      isLoading.value = true;
      var response = await WebServiceManager()
          .register(email: emailController.text, password: passwordController.text, firstName: firstNameController.text, lastName: lastNameController.text);
      print("response from register : ${response}");

      _navigateToHomeController();

      } else {
        ViewUtils().showSnackbar(context, "Erreur lors de l'inscription");
      }
      isLoading.value = false;

  }

  onLoginClicked() {
    _navigateToLoginController();
  }

  //endregion

  //region Navigation
  _navigateToHomeController() async {
    NavigationUtils().navigateTo(context, const MainNavigationViewController());
  }

  _navigateToLoginController() {
    NavigationUtils().navigateToWithReplacementWithRoot(context, const LoginViewController());
  }
//endregion

//endregion
}
