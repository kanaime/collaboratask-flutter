import 'package:collaboratask/managers/SyncroManager.dart';
import 'package:collaboratask/utils/network_utils.dart';
import 'package:collaboratask/utils/view_utils.dart';
import 'package:flutter/cupertino.dart';

import 'WebServiceManager.dart';

class SyncroManager {
  static SyncroManager? _instance;

  SyncroManager._internal();

  factory SyncroManager() => _instance ?? SyncroManager._internal();

  static const time_out_seconds_duration = Duration(seconds: 60);

  Future<void> sync() async {
    // Sync data with server
  }

   syncData() async {

    if(await NetworkUtils().isNetworkAvailable()){

      await WebServiceManager().getProjectsAndProjectUser();
      await WebServiceManager().getTasks();
      //await WebServiceManager().getUsers();
      await WebServiceManager().getUserInfo();
    return true;
    }
    else{

      print("No internet connection");
      return false;
    }
  }
}