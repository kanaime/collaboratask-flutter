import 'package:collaboratask/database/models/Project.dart';
import 'package:collaboratask/database/ressources/synchronizable_entity.dart';
import 'package:collaboratask/database/ressources/synchronizable_repository.dart';

import '../daos/ProjectDao.dart';

class ProjectRepository extends SynchronizableRepository<Project>{

  static final ProjectRepository _instance = ProjectRepository._internal();

  factory ProjectRepository() {
    return _instance;
  }

  ProjectRepository._internal();
  
  @override
  deleteByLocalId(int localId) {
    return (dao as ProjectDao).deleteByLocalId(localId);
  }

  @override
  deleteByServerId(int serverId) {
    return (dao as ProjectDao).deleteByServerId(serverId);
  }

  @override
  Future<List<Project>> getAll() {
    return (dao as ProjectDao).getAll();
  }

  @override
  Future<Project?> getByLocalId(int entityId) {
    return (dao as ProjectDao).getByLocalId(entityId).first;
  }

  @override
  Future<Project?> getByServerId(int entityId) {
    return (dao as ProjectDao).getByServerId(entityId).first;
  }


  @override
  saveAll(List<Project> entitiesToCreate, List<Project> entitiesToUpdate) {
   return (dao as ProjectDao).insertAll(entitiesToCreate);
  }

  Future<int> insert(Project project) async {
    project.localId = await (dao as ProjectDao).insert(project);
    return project.localId!;
  }

  @override
  Future<Project> fromJson(Map<String, dynamic> json) async {
   return Project.fromJson(json);
  }

  @override
  Future<Map<String, dynamic>> toJson(Project entity)async {
    return await entity.toJson();
  }

 @override
  Future<int> update(Project entity)async{
    return await (dao as ProjectDao).update(entity);
  }

  @override
  Future<void> deleteAll()async{
    return await (dao as ProjectDao).deleteAll();
  }

}