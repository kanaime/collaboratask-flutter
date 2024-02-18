import 'package:collaboratask/database/models/Task.dart';
import 'package:collaboratask/database/ressources/synchronizable_entity.dart';
import 'package:collaboratask/database/ressources/synchronizable_repository.dart';
import 'package:collaboratask/ressources/enum/EnumStatus.dart';

import '../daos/TaskDao.dart';

class TaskRepository extends SynchronizableRepository<Task>{

  static final TaskRepository _instance = TaskRepository._internal();

  factory TaskRepository() {
    return _instance;
  }

  TaskRepository._internal();


  @override
  deleteByLocalId(int localId) {
    return (dao as TaskDao).deleteByLocalId(localId);
  }

  @override
  deleteByServerId(int serverId) {
   return (dao as TaskDao).deleteByServerId(serverId);
  }

  @override
  Future<List<Task>> getAll() {
    return (dao as TaskDao).getAll();
  }

  @override
  Future<Task?> getByLocalId(int entityId) {
    return (dao as TaskDao).getByLocalId(entityId).first;
  }

  @override
  Future<Task?> getByServerId(int entityId) {
    return (dao as TaskDao).getByServerId(entityId).first;
  }


  @override
  saveAll(List<Task> entitiesToCreate, List<Task> entitiesToUpdate) {
    return (dao as TaskDao).insertAll(entitiesToCreate);
  }

  Future<int> insert(Task task) async {
    task.localId = await (dao as TaskDao).insert(task);
    return task.localId!;
  }
  @override
  Future<List<Task>>getAllByProjectId(int projectId) async {
    return (dao as TaskDao).getAllByProjectId(projectId);
  }
  @override
  Future<int> update(Task task) async {
    return (dao as TaskDao).update(task);
  }


  getCountTaskByProject(int projectId) async {
    List<Task> tasks = await (dao as TaskDao).getAllByProjectId(projectId);
   return tasks.length;
  }

  getCountTaskDoneByProject(int projectId) async {
    List<Task> tasks = await (dao as TaskDao).getAllByProjectId(projectId);
    int count = 0;
    for(Task task in tasks){
      if(task.status == EnumStatus.FINISHED.getValue()){
        count++;
      }
    }
    return count;
  }
  Future<double>?getPercetageTaskDoneByProject(int projectId) async {
    int count = await getCountTaskDoneByProject(projectId);
    int tasksLength = await getCountTaskByProject(projectId);
    return count/tasksLength*100.toInt();
  }

  @override
  Future<Task> fromJson(Map<String, dynamic> json)async {
   return Task.fromJson(json);
  }

  @override
  Future<Map<String, dynamic>> toJson(Task entity) async{
   return entity.toJson();
  }

  @override
  Future<void>deleteAll()async {
    return await (dao as TaskDao).deleteAll();
  }

}