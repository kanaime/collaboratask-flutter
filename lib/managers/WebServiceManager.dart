import 'dart:convert';

import 'package:collaboratask/database/models/UserInfo.dart';
import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/database/repository/TaskRepository.dart';
import 'package:collaboratask/database/repository/UserInfoRepository.dart';
import 'package:collaboratask/database/repository/UserRepository.dart';
import 'package:collaboratask/managers/FirebaseAuthManager.dart';
import 'package:collaboratask/managers/ProjectManager.dart';
import 'package:collaboratask/managers/UserManager.dart';
import 'package:collaboratask/ressources/Constant.dart';
import 'package:http/http.dart' as http;

import '../database/models/Project.dart';
import '../database/models/ProjectUser.dart';
import '../database/models/Task.dart';
import '../database/models/User.dart';
import '../database/models/modelsView/ProjectInfo.dart';
import '../database/repository/ProjectUserRepository.dart';
import '../main.dart';
import 'SyncroManager.dart';

class WebServiceManager {
  static WebServiceManager? _instance;

  WebServiceManager._internal();

  factory WebServiceManager() => _instance ?? WebServiceManager._internal();

  static const time_out_seconds_duration = Duration(seconds: 60);

  //region UTILS

  Future getProjectsAndProjectUser() async {
    await ProjectRepository().deleteAll();
    await ProjectUserRepository().deleteAll();
    final response = await http.get(Uri.parse(Constant.API_URL_PROJECT + "/getAll"));
    List<Project> projects = [];

    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      List jsonResponse = jsonDecode(response.body);

      for (var objectJson in jsonResponse) {
        print("element====> : " + objectJson.toString());
        getProjectUserFromProjectJson(objectJson);

        Project project = Project.fromJson(objectJson);

        projects.add(project);
      }
      ProjectRepository().saveAll(projects, projects);
      return projects;
    } else {
      throw Exception('Failed to load projects');
    }
  }

  getProjectUserFromProjectJson(Map<String, dynamic> project)async {
    print("getProjectUserFromProjectJson -> ");
  print("project recu from fonction : " + project.toString());
    List<ProjectUser> projectUsers =[];
    for(var userId in project["users"]){
      print("user id : " + userId.toString());



      String date = DateTime.now().toString();
      ProjectUser projectUser = ProjectUser(
        projectId: project["id"],
        userId: userId, localId: null, id: null, creationDate: date, lastUpdate: date,

      );
      projectUsers.add(projectUser);
    }
    print("projectUsers  tableau remplis : " + projectUsers.toString());
    var response = await ProjectUserRepository().saveAll(projectUsers, projectUsers);
    print("response from saveAll : " + response.toString());

  }

  Future getUserInfo() async {
    await UserInfoRepository().deleteAll();
    final response = await http.get(Uri.parse(Constant.API_URL_USER + "/getAll"));
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      var jsonResponse = jsonDecode(response.body);
      for (var element in jsonResponse) {
        UserInfo userInfo = UserInfo.fromJson(element);
        UserInfoRepository().insert(userInfo);
      }
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future getUsers() async {
    await UserRepository(database!.userDao).deleteAll();
    final response = await http.get(Uri.parse(Constant.API_URL_USER + "/getAll"));
    List<User> users = [];

    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      List jsonResponse = jsonDecode(response.body);
      for (var element in jsonResponse) {
        User user = User.fromJson(element);
        print("-> user : " + user.toString());

        users.add(user);
      }
      print("users  array : " + users.toString());
      UserRepository(database!.userDao).saveAll(users, users);
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
  getTasks() async {
    await TaskRepository().deleteAll();
    final response = await http.get(Uri.parse(Constant.API_URL_TASK + "/getAll"));
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      var jsonResponse = jsonDecode(response.body);
      for (var element in jsonResponse) {
        print("element====> : " + element.toString());
        Task task = Task.fromJson(element);
        TaskRepository().insert(task);

      }
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  cleanUserTable() async {
    UserRepository(database!.userDao).deleteAll();
  }


  getUserConnected(String firebaseId)async {
    print("getUserConnected -> " + firebaseId.toString());
    await cleanUserTable();


    final reponse = await http.get(Uri.parse(Constant.API_URL_USER + "/uid/" + firebaseId));

    if(reponse.statusCode == 200) {
      var jsonResponse = jsonDecode(reponse.body);
      User user = User.fromJson(jsonResponse);
      UserRepository(database!.userDao).getByServerId(user.id!).then((value) {
        if(value == null){
          UserRepository(database!.userDao).insert(user);
        }
      });
    }else{
      throw Exception('Failed to load user connected');
    }
  }

  Future<Project>sendNewProject(ProjectInfo project) async {
    final response = await http.post(Uri.parse(Constant.API_URL_PROJECT), body: jsonEncode(project), headers: Constant.headers);
    if (response.statusCode == 201) {
      print("response from WS : " + response.statusCode.toString());
      Project responseProject = Project.fromJson(jsonDecode(response.body));
      print("responseProject : " + responseProject.toJson().toString());
      return responseProject;

    } else {
      print("error");
      throw Exception('Failed to load projects');
    }
  }

  ///
  /// EDIT PROJECT
  ///

  Future<ProjectInfo> editProject( int id, element) async {
    element = jsonDecode(element);
    var projectToSend = jsonEncode(element);


    print("projectToSend Encoder : " + projectToSend.toString());
    final response = await http.put(Uri.parse("${Constant.API_URL_PROJECT}/updateProject/$id"), body: projectToSend, headers: Constant.headers);
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      //await SyncroManager().syncData();
      print("response.body dans le WS : " + response.body);

      ProjectInfo responseProjectInfoFromJson = ProjectInfo.fromJson(jsonDecode(response.body));
      print("ProjectInfo.fromJson Decode  : " + responseProjectInfoFromJson.toJson().toString());

      Project? responseProject =  Project.fromJson(jsonDecode(response.body));
      print("Project.fromJson Decode : " + responseProject.toJson().toString());

      Project? projectToUpdate = await ProjectRepository().getByServerId(responseProject.id!);
      print("projectToUpdate : " + projectToUpdate!.toJson().toString());

      int idUpdate = await ProjectRepository().update(projectToUpdate);
      print("id project update : " + idUpdate.toString());
      if(idUpdate == 0){
        await ProjectRepository().insert(projectToUpdate);
      }else{
        await ProjectRepository().deleteByLocalId(projectToUpdate.localId!);
        var idReturn = await ProjectRepository().insert(responseProject);
        print("idReturn : " + idReturn.toString());
      }

      responseProject = await ProjectRepository().getByServerId(projectToUpdate.id!);
      print("responseProject after getByLocalId : " + responseProject!.toJson().toString());

      await ProjectUserRepository().deleteByProjectId(responseProject.id!);
      print("delete project_user");

      await getProjectUserFromProjectJson(responseProjectInfoFromJson.toJson());


      ProjectInfo responseProjectInfo = await ProjectManager().convertProjectToProjectInfo(responseProject);
      print("responseProject : " + responseProjectInfo.toJson().toString());
      return responseProjectInfo;

    } else {
      print("error");
      throw Exception('Failed to load projects');
    }
  }

  ///
  /// Add Task
  ///
  Future<Task> addTask(Task task) async {
    final response = await http.post(Uri.parse(Constant.API_URL_TASK), body: jsonEncode(task), headers: Constant.headers);
    print("response from WS : " + response.statusCode.toString());
    if (await response.statusCode == 201) {
      print("response from WS : " + response.statusCode.toString());
      Task responseTask = Task.fromJson(jsonDecode(response.body));
      print("responseTask : " + responseTask.toJson().toString());
      Task? getTask = await TaskRepository().getByServerId(responseTask.id!);
      if(getTask == null){
       await TaskRepository().insert(responseTask);
      }
      return responseTask;

    } else {
      print("error");
      throw Exception('Failed to load tasks');
    }
  }
  ///
/// EDIT TASK
///
  Future<Task?> editTask( int id, element) async {
    element = jsonDecode(element);
    var taskToSend = jsonEncode(element);
    print("taskToSend Encoder : " + taskToSend.toString());
    final response = await http.put(Uri.parse("${Constant.API_URL_TASK}/updateTask/$id"), body: taskToSend, headers: Constant.headers);
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      Task? responseTask = Task.fromJson(jsonDecode(response.body));
      print("responseTask : " + responseTask.toJson().toString());

      Task? responseTaskToUpdate = await TaskRepository().getByServerId(responseTask.id!);
      print("responseTaskToUpdate : " + responseTaskToUpdate!.toJson().toString());
      int idUpdate = await TaskRepository().update(responseTaskToUpdate);
      print("id task update : " + idUpdate.toString());
      if(idUpdate == 0){
        await TaskRepository().insert(responseTask);
      }else{
        await TaskRepository().deleteByLocalId(responseTaskToUpdate.localId!);
        var idReturn = await TaskRepository().insert(responseTask);
        print("idReturn : " + idReturn.toString());
        responseTask = await TaskRepository().getByServerId(idReturn);
      }

      return responseTask;

    } else {
      print("error");
      throw Exception('Failed to load tasks');
    }
  }
  ///
  /// DELETE TASK
  ///
  Future<Task> deleteTask( int id) async {
    final response = await http.delete(Uri.parse("${Constant.API_URL_TASK}/deleteTask/$id"), headers: Constant.headers);
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      Task responseTask = Task.fromJson(jsonDecode(response.body));
      print("responseTask : " + responseTask.toJson().toString());
      await TaskRepository().deleteByServerId(responseTask.id!);
      return responseTask;

    } else {
      print("error");
      throw Exception('Failed to load tasks');
    }
  }
  ///
  /// DELETE PROJECT
  ///
  Future<Project> deleteProject( int id) async {
    final response = await http.delete(Uri.parse("${Constant.API_URL_PROJECT}/deleteProject/$id"), headers: Constant.headers);
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      Project responseProject = Project.fromJson(jsonDecode(response.body));
      print("responseProject : " + responseProject.toJson().toString());
      await ProjectRepository().deleteByServerId(responseProject.id!);
      return responseProject;

    } else {
      print("error");
      throw Exception('Failed to load projects');
    }
  }
  ///
  /// EDIT USER
  ///

  Future<User> editUser( int id, element) async {
    element = jsonDecode(element);
    var userToSend = jsonEncode(element);
    print("userToSend Encoder : " + userToSend.toString());
    final response = await http.put(Uri.parse("${Constant.API_URL_USER}/update/$id"), body: userToSend, headers: Constant.headers);
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      User responseUser = User.fromJson(jsonDecode(response.body));
      print("responseUser : " + responseUser.toJson().toString());
      User? responseUserToUpdate = await UserRepository(database!.userDao).getByServerId(responseUser.id!);
      print("responseUserToUpdate : " + responseUserToUpdate!.toJson().toString());
      int idUpdate = await UserRepository(database!.userDao).update(responseUserToUpdate);
      print("id user update : " + idUpdate.toString());
      if(idUpdate == 0){
        await UserRepository(database!.userDao).insert(responseUser);
      }else{
        await UserInfoRepository().deleteByServerId(responseUserToUpdate.id!);
        await UserInfoRepository().insert(UserInfo.fromJson(responseUser.toJson()));
        await UserRepository(database!.userDao).deleteByLocalId(responseUserToUpdate.localId!);
        var idReturn = await UserRepository(database!.userDao).insert(responseUser);
        print("idReturn : " + idReturn.toString());
        UserManager().reset();
      }
      return responseUser;

    } else {
      print("error");
      throw Exception('Failed to load users');
    }
  }

  ///
/// LOGIN USER
///
  Future<String> login(String email, String password) async{

    var response =  await FirebaseAuthManager().signInWithEmailAndPassword(email: email, password: password).then((value) async {
        print('value : $value');
        if(value != null){
          await getUserConnected(value.uid);
        }else{
          print("error");
        }
        return value;
      });
    print("response : " + response.toString());
    if(response != null){
      return "success";
    }else{
      return "error";
    }

  }
  ///
/// REGISTER USER
///
  Future<User?> register({required String email, required String password, required String firstName, required String lastName}) async{
    try {
      print("register");
      await FirebaseAuthManager().createUserWithEmailAndPassword(email: email, password: password).then((value) async {
        print('value : $value');
        if(value != null){
          print('value not null : $value');
          print('value.uid : ${value.uid}');
          var token = await value.getIdTokenResult().then((value) => value.token);
          print('token : ${token}');

          //await getUserConnected(value.uid);
          var response = await newUser(email: email, password: password, firstName: firstName, lastName: lastName, firebaseId: value.uid, token: token!);
          print('response User : ${response}');
          return response;
        }else{
          print("error");
          throw Exception('Failed to load user');

        }
      });

    } catch (e) {
      print("error $e");
      throw Exception('Failed to load users $e');
    }

  }

  Future<User> newUser({required String email, required String password, required String firstName, required String lastName, required String firebaseId, required String token}) async {
    print('newUser');
    var userTosend = jsonEncode({"email": email, "password": password, "firstName": firstName, "lastName": lastName, "firebaseId": firebaseId, "token": token});
    final response = await http.post(Uri.parse(Constant.API_URL_USER), body: userTosend, headers: Constant.headers);
    if (response.statusCode == 201) {
      print("response from WS : " + response.statusCode.toString());
      User responseUser = User.fromJson(jsonDecode(response.body));
      print("responseUser : " + responseUser.toJson().toString());
        await UserRepository(database!.userDao).insert(responseUser);

      await getUserConnected(firebaseId);
      return responseUser;

    } else {
      print("error");
      throw Exception('Failed to load users');
    }

  }
  ///
}
