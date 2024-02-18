import 'dart:async';


import 'package:collaboratask/database/daos/ProjectUserDao.dart';
import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/database/repository/ProjectUserRepository.dart';
import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/database/repository/UserRepository.dart';
import 'package:collaboratask/database/ressources/synchronizable_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/ProjectDao.dart';
import 'daos/TaskDao.dart';
import 'daos/UserDao.dart';
import 'daos/UserInfoDao.dart';
import 'models/Project.dart';
import 'models/ProjectUser.dart';
import 'models/Task.dart';
import 'models/User.dart';
import 'models/UserInfo.dart';



part 'AppDatabase.g.dart'; // the generated code will be there


@Database(
  version: 1,
  entities: [
    Project,
    Task,
    UserInfo,
    User,
    ProjectUser,
  ],
  views: [

  ],
)

abstract class AppDatabase extends FloorDatabase {
  static const DATABASE_PATH = 'app_database.db';


  ProjectDao get projectDao ;
  TaskDao get taskDao ;
  UserDao get userDao ;
  UserInfoDao get userInfoDao ;
  ProjectUserDao get projectUserDao ;




  setDaoForDb() {
      ProjectRepository().setDao(projectDao);
      TaskRepository().setDao(taskDao );
      UserRepository(userDao).setDao(userDao);
      UserInfoRepository().setDao(userInfoDao);
      ProjectUserRepository().setDao(projectUserDao);


  }
  Future<void> cleanDatabase(bool deleteDatabase) async {
    if (deleteDatabase) {
      sqfliteDatabaseFactory.deleteDatabase(DATABASE_PATH);

    }
  }
}