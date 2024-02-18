import 'package:collaboratask/database/models/User.dart';
import 'package:collaboratask/database/ressources/synchronizable_entity.dart';
import 'package:collaboratask/database/ressources/synchronizable_repository.dart';

import '../daos/UserDao.dart';

class UserRepository extends SynchronizableRepository<User>{
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository(UserDao userDao) {
    _instance.dao = userDao;
    return _instance;
  }

  UserRepository._internal();
  
  @override
  deleteByLocalId(int localId) {
    return (dao as UserDao).deleteByLocalId(localId);
  }

  @override
  deleteByServerId(int serverId) {
    return (dao as UserDao).deleteByServerId(serverId);
  }

  @override
  Future<List<User>> getAll() {
    return (dao as UserDao).getAll();
  }

  @override
  Future<User?> getByLocalId(int entityId) {
   return (dao as UserDao).getByLocalId(entityId).first;
  }

  @override
  Future<User?> getByServerId(int entityId) async {
   return await (dao as UserDao).getByServerId(entityId);
  }


  @override
  saveAll(List<User> entitiesToCreate, List<User> entitiesToUpdate) {
   return (dao as UserDao).insertAll(entitiesToCreate);
  }

  Future<int> insert(User user) async {
    user.localId = await (dao as UserDao).insert(user);
    return user.localId!;
  }

  @override
  Future<List<User>>findUserInProject(int projectId, int userId) {
    return (dao as UserDao).findUserInProject(projectId, userId);
  }

  @override
  Future<List<User>> getUsersInProject(int projectId) {
    return (dao as UserDao).getUsersInProject(projectId);
  }
  @override
  Future<int> update(User entity) {
    return (dao as UserDao).update(entity);
  }

  @override
  Future<SynchronizableEntity> fromJson(Map<String, dynamic> json) async {
    return User.fromJson(json);
  }

  @override
  Future<Map<String, dynamic>> toJson(User entity) async{
   return entity.toJson();
  }

  Future<User?> getCurrentUser() async {
    return await (dao as UserDao).getCurrentUser().first;
  }

  Future<void>deleteAll() async {
    return await (dao as UserDao).deleteAll();
  }

}