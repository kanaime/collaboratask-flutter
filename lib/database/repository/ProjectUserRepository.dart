import 'package:collaboratask/database/models/ProjectUser.dart';
import 'package:collaboratask/database/ressources/synchronizable_entity.dart';
import 'package:collaboratask/database/ressources/synchronizable_repository.dart';

import '../daos/ProjectUserDao.dart';

class ProjectUserRepository extends SynchronizableRepository<ProjectUser>{

  static final ProjectUserRepository _instance = ProjectUserRepository._internal();

  factory ProjectUserRepository() {
    return _instance;
  }

  ProjectUserRepository._internal();

  @override
  deleteByLocalId(int localId) {
    return (dao as ProjectUserDao).deleteByLocalId(localId);
  }

  @override
  deleteByServerId(int serverId) {
    return (dao as ProjectUserDao).deleteByServerId(serverId);
  }

  @override
  Future<List<SynchronizableEntity>> getAll() {
    return (dao as ProjectUserDao).getAll();
  }

  @override
  Future<SynchronizableEntity?> getByLocalId(int entityId) {
    return (dao as ProjectUserDao).getByLocalId(entityId).first;
  }

  @override
  Future<SynchronizableEntity?> getByServerId(int entityId) {
    return (dao as ProjectUserDao).getByServerId(entityId).first;
  }
  @override
  Future<List<ProjectUser>> getByProjectId(int projectId) {
    return (dao as ProjectUserDao).getByProjectId(projectId);
  }

  @override
  Future<List<ProjectUser>> getByUserId(int userId) {
    return (dao as ProjectUserDao).getByUserId(userId);
  }


  @override
  saveAll(List<ProjectUser> entitiesToCreate, List<ProjectUser> entitiesToUpdate) {
    return (dao as ProjectUserDao).insertAll(entitiesToCreate);
  }

  Future<int> insert(ProjectUser projectUser) async {
    projectUser.localId = await (dao as ProjectUserDao).insert(projectUser);
    return projectUser.localId!;
  }

  @override
  Future<ProjectUser> fromJson(Map<String, dynamic> json) async {
    return ProjectUser.fromJson(json);
  }

  @override
  Future<Map<String, dynamic>> toJson(ProjectUser entity)async {
    return await entity.toJson();
  }
  @override
  Future<void> deleteAll()async {
    return await (dao as ProjectUserDao).deleteAll();
  }

  @override
  Future<void> deleteByProjectId(int projectId)async {
    return await (dao as ProjectUserDao).deleteByProjectId(projectId);
  }

}