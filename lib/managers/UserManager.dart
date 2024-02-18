import 'package:collaboratask/utils/navigation_utils.dart';

import '../database/models/User.dart';
import '../database/repository/UserRepository.dart';
import '../main.dart';
import 'FirebaseAuthManager.dart';

class UserManager {
  static UserManager? _instance;

  UserManager._internal();

  factory UserManager() => _instance ?? UserManager._internal();

  static User? _currentUser;

  Future<User?> getCurrentUser() async {
    print('UserManager getCurrentUser');
    if (_currentUser != null) {
      print('User already loaded from memory ' + _currentUser!.email);
      return _currentUser!;
    }
    print('user is null');
    var user = await UserRepository(database!.userDao).getAll();
    if(user.isNotEmpty){
      print('user is not empty');
      _currentUser = await UserRepository(database!.userDao).getCurrentUser();
      print('User loaded from database ' + _currentUser!.email);
      return _currentUser;
    }else{
      print('user is empty');
      return null;
    }
  }



  void reset() async {
    _currentUser = null;
    await UserRepository(database!.userDao).deleteAll();
  }
  logout() {
     FirebaseAuthManager().signOut();
    reset();
  }
}