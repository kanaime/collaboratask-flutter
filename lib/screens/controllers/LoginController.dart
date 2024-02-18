
import 'package:collaboratask/managers/WebServiceManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../managers/UserManager.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/LoginView.dart';
import 'MainNavigationControlller.dart';
import 'RegisterController.dart';

class LoginViewController extends StatefulWidget {
  const LoginViewController({super.key});

  @override
  LoginController createState() {
    return LoginController();
  }
}

class LoginController extends State<LoginViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  final loginFormKey = GlobalKey<FormState>();

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
    return LoginView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;
    if (kDebugMode){
      emailController.text = "toto@toto.com";
      passwordController.text = "Test1234.";
    }

    isLoading.value = false;
  }
  //endregion
  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message, style: const TextStyle(color: Colors.white)),
    ));
  }

  showPopup(BuildContext context, String title, String description, String validateText, bool redButton, bool disabledButton, Function() onValidatePressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                onLogOutClicked();
              },
              child: const Text('Déconnexion'),
            ),
            TextButton(
              onPressed: onValidatePressed,
              child: Text(validateText),
            ),
          ],
        );
      },
    );
  }

  //region User Actions

  onTogglePassword() {
      isPasswordVisible.value = !isPasswordVisible.value;
  }

  onSignUpClicked() {
    _navigateToSignUpController();
  }

  onLoginClicked() {
    try {
      if (loginFormKey.currentState!.validate()) {
        loginFormKey.currentState!.save();
        _login();
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  onLogOutClicked() async{
    await UserManager().logout();
  }

  //endregion

  _login() async {
    isLoading.value = true;
    if (await NetworkUtils().isNetworkAvailable()) {
      print("network ok");
      var response = await WebServiceManager().login(emailController.text, passwordController.text);
      print("response-->: $response");
      if (response != "success") {
        showSnackBar(context, "Erreur email ou mot de passe incorrecte ");
      } else {
        _navigateToHomeController();
      }
    } else {
      showSnackBar(context, "Pas de connexion internet");
    }
    isLoading.value = false;
  }

  //region Navigation
  _navigateToHomeController() async {

    NavigationUtils().navigateTo(context, const MainNavigationViewController());

  }
  _navigateToSignUpController() async {

    NavigationUtils().navigateToWithReplacementWithRoot(context, const RegisterViewController());

  }
//endregion


//endregion
}
