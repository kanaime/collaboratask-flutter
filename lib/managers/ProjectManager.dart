import 'dart:convert';

import 'package:collaboratask/database/models/modelsView/ProjectInfo.dart';
import 'package:collaboratask/database/repository/ProjectRepository.dart';
import 'package:collaboratask/managers/UserInfoManager.dart';
import 'package:flutter/cupertino.dart';

import '../database/models/Project.dart';
import 'package:http/http.dart' as http;

import '../ressources/Constant.dart';

class ProjectManager {
  static final ProjectManager _instance = ProjectManager._internal();

  factory ProjectManager() {
    return _instance;
  }

  ProjectManager._internal();

  static ProjectInfo? _currentProject;


  final List<Project> _projects = [];

  List<Project> get projects => _projects;

  Future<ProjectInfo> getCurrentProject() async {
    if (_currentProject != null) {
      return _currentProject!;
    }
   Project? project = await ProjectRepository().getByServerId(1);
    _currentProject = await convertProjectToProjectInfo(project!);
    return _currentProject!;
  }

  setCurrentProject(int projectId) async {


    Project? project = await ProjectRepository().getByServerId(projectId);
    print("projt from projetManager : " + project!.toJson().toString());

    _currentProject = await convertProjectToProjectInfo(project);
  }

  reset() {
    _currentProject = null;
  }



  addProject(Project project) async {
    print("project fonction add : " + project.toJson().toString());
    var projectToSend = await convertProjectToProjectInfo(project);
    print("projectToSend : " + projectToSend.toJson().toString());
    final response = await http.post(Uri.parse(Constant.API_URL_PROJECT), body: jsonEncode(projectToSend), headers: Constant.headers);
    print("response from WS : " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("response from WS : " + response.statusCode.toString());
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load projects');
    }
  }

  void removeProject(Project project) {
    _projects.remove(project);
  }

  Future<ProjectInfo> convertProjectToProjectInfo(Project project) async {

    ProjectInfo projectInfo = ProjectInfo(
        id: project.id,
        localId: project.localId,
        name: project.name,
        description: project.description,
        status: project.status,
        creator: project.creator,
        creationDate: project.creationDate,
        lastUpdate: project.lastUpdate,
        users: await UserInfoManager().getUsersIdForProject(project.id!),
        userInfos: await UserInfoManager().getUsersForProject(project.id!));
    return projectInfo;
  }

  convertProjectInfoToProject(ProjectInfo projectInfo) {
    return Project(
      id: projectInfo.id,
      localId: projectInfo.localId,
      name: projectInfo.name,
      description: projectInfo.description,
      status: projectInfo.status,
      creator: projectInfo.creator,
      creationDate: projectInfo.creationDate,
      lastUpdate: projectInfo.lastUpdate,
    );
  }

  convertListProjectToListProjectInfo(List<Project> projects) async {
    List<ProjectInfo> projectsInfo = [];
    for (var project in projects) {
      projectsInfo.add(await convertProjectToProjectInfo(project));
    }
    return projectsInfo;
  }
}
